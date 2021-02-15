package mongo

import (
	"context"
	"time"

	"github.com/damonallison/notes/data-science/mongodb/sample/models"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"go.mongodb.org/mongo-driver/mongo/readconcern"
	"go.mongodb.org/mongo-driver/mongo/readpref"
	"go.mongodb.org/mongo-driver/mongo/writeconcern"
)

// Config ...
type Config struct {
	uri  string
	db   string
	coll string
}

// ConfigOption ...
type ConfigOption func(*Config)

// WithURI ...
func WithURI(uri string) ConfigOption {
	return func(c *Config) {
		c.uri = uri
	}
}

// WithDatabase ...
func WithDatabase(db string) ConfigOption {
	return func(c *Config) {
		c.db = db
	}
}

// WithCollection ...
func WithCollection(coll string) ConfigOption {
	return func(c *Config) {
		c.coll = coll
	}
}

// Client ...
type Client struct {
	cfg  *Config
	mc   *mongo.Client
	db   *mongo.Database
	coll *mongo.Collection
}

// NewClient ...
func NewClient(opts ...ConfigOption) (*Client, error) {
	const (
		defaultURI = "mongodb://127.0.0.1:27017"
	)
	c := &Client{
		cfg: &Config{
			uri: defaultURI,
		},
	}
	for _, opt := range opts {
		opt(c.cfg)
	}

	client, err := mongo.NewClient(options.Client().ApplyURI(c.cfg.uri))
	if err != nil {
		return nil, err
	}
	ctx, _ := context.WithTimeout(context.Background(), 1*time.Second)
	err = client.Connect(ctx)
	if err != nil {
		return nil, err
	}
	err = client.Ping(ctx, readpref.Primary())
	if err != nil {
		return nil, err
	}
	c.db = client.Database(c.cfg.db)
	c.coll = c.db.Collection(c.cfg.coll)
	c.mc = client
	return c, nil
}

// ListDatabases ...
func (c *Client) ListDatabases(ctx context.Context) ([]string, error) {
	return c.mc.ListDatabaseNames(ctx, bson.M{})
}

// Disconnect ...
func (c *Client) Disconnect(ctx context.Context) error {
	return c.mc.Disconnect(ctx)
}

// Create ...
func (c *Client) Create(ctx context.Context, driver models.Driver) (models.Driver, error) {
	drivers, err := c.CreateMany(ctx, driver)
	if err != nil {
		return models.Driver{}, err
	}
	return drivers[0], nil
}

// CreateMany ...
func (c *Client) CreateMany(ctx context.Context, drivers ...models.Driver) ([]models.Driver, error) {
	islice := make([]interface{}, len(drivers))
	for i := range drivers {
		islice[i] = drivers[i]
	}
	iDrivers, err := c.withTX(ctx, func(sessionCtx mongo.SessionContext) (interface{}, error) {
		res, err := c.coll.InsertMany(ctx, islice)
		if err != nil {
			return nil, err
		}
		for i := range drivers {
			drivers[i].ID = res.InsertedIDs[i].(primitive.ObjectID)
		}
		return drivers, nil
	})
	if err != nil {
		return nil, err
	}
	return iDrivers.([]models.Driver), nil
}

// Find ...
// Update ...
// Delete ...

func (c *Client) withTX(ctx context.Context, f func(sessionCtx mongo.SessionContext) (interface{}, error)) (interface{}, error) {
	//
	// Read / write operations with "majority" will only read /write data that
	// was acknowledged by a majority of replica set members.
	//
	// For multi-document transactions, "majority" read operations can only
	// guarantee it will read data acknowledged by the majority of replicas if
	// the write transaction is "majority".
	wc := writeconcern.New(writeconcern.WMajority())

	// The "local" read concern will return data from your local instance
	// without guarantees the data has been written to multiple members.
	//
	// The "available" read concern is similar to "local", but works with
	// sharded collections. For non-sharded collections, "local" and "available"
	// are the same.
	//
	// The "majority" read concern guarantees data has been acknowledged by
	// multiple replica set members.
	//
	// The "linearizable" read concern returns data that is guaranteed to not be
	// stale. However, it only allows you to read a single document.
	//
	rc := readconcern.Majority()

	txnOpts := options.Transaction().SetWriteConcern(wc).SetReadConcern(rc)

	// TODO: When should we start a session? Probably not for every transaction.
	session, err := c.mc.StartSession()
	if err != nil {
		return nil, err
	}
	defer session.EndSession(ctx)

	// WithTransaction implements retry logic for known Mongo errors:
	//
	// TransientTransactionError (i.e., the primary node has stepped down)
	// https://docs.mongodb.com/manual/core/transactions-in-applications/#transient-transaction-error
	//
	// UnknownTransactionCommitResult (i.e., the TX encountered network errors or couldn't find a healthy primary)
	// https://docs.mongodb.com/manual/core/transactions-in-applications/#unknowntransactioncommitresult
	return session.WithTransaction(ctx, f, txnOpts)
}
