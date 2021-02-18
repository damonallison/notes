package db

import (
	"context"
	"log"
	"time"

	"github.com/shipt/damon/mongodb/internal/models"
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

// FindAll ...
func (c *Client) FindAll(ctx context.Context) ([]models.Driver, error) {
	return c.findWithFilter(ctx, bson.D{})
}

// FindByFirstName ...
func (c *Client) FindByFirstName(ctx context.Context, fname string) ([]models.Driver, error) {
	return c.findWithFilter(ctx, bson.D{
		bson.E{Key: "first_name", Value: fname},
	})
}

// FindByCertName ...
func (c *Client) FindByCertName(ctx context.Context, name string) ([]models.Driver, error) {
	// Finds all documents where the certifications array has at least one certification named `name`
	return c.findWithFilter(ctx, bson.D{
		bson.E{
			Key:   "certifications.name",
			Value: name,
		},
	})
}

func (c *Client) findWithFilter(ctx context.Context, filter bson.D) ([]models.Driver, error) {
	cur, err := c.coll.Find(ctx, filter, options.Find())
	if err != nil {
		return nil, err
	}
	drivers := make([]models.Driver, 0)
	for cur.Next(ctx) {
		var d models.Driver
		if err := cur.Decode(&d); err != nil {
			return nil, err
		}
		drivers = append(drivers, d)
	}
	if err := cur.Close(ctx); err != nil {
		return nil, err
	}
	return drivers, nil
}

// Update ...
func (c *Client) Update(ctx context.Context, driver models.Driver) (models.Driver, error) {
	res, err := c.coll.ReplaceOne(ctx, bson.D{
		bson.E{
			Key:   "_id",
			Value: driver.ID,
		},
	},
		driver,
		options.Replace().SetUpsert(true))

	if err != nil {
		return models.Driver{}, err
	}
	if res.UpsertedCount > 0 {
		driver.ID = res.UpsertedID.(primitive.ObjectID)
	}
	return driver, nil
}

// Delete ...
func (c *Client) Delete(ctx context.Context, drivers ...models.Driver) error {
	ids := make([]interface{}, len(drivers))
	for i, d := range drivers {
		ids[i] = d.ID
	}
	doc := bson.D{
		bson.E{
			Key: "_id",
			Value: bson.D{
				bson.E{
					Key:   "$in",
					Value: ids,
				},
			},
		},
	}
	_, err := c.coll.DeleteMany(ctx, doc, options.Delete())
	return err
}

// Watch starts a change stream
func (c *Client) Watch(ctx context.Context, change chan<- bson.D, done chan<- error) {
	stream, err := c.coll.Watch(ctx, mongo.Pipeline{})
	if err != nil {
		done <- err
	}
	defer func() {
		if err := stream.Close(ctx); err != nil {
			log.Printf("error closing change stream: %v\n", err)
		}
	}()
	for stream.Next(ctx) {
		var data bson.D
		if err := stream.Decode(&data); err != nil {
			done <- err
			return
		}
		change <- data
	}
	done <- nil
}

func (c *Client) withTX(ctx context.Context, f func(sessionCtx mongo.SessionContext) (interface{}, error)) (interface{}, error) {

	// NOTE: Use `majority`
	//
	// MongoDB uses `majority` for all cluster configuration read/write
	// operations. If `majority` is what they use, consider using `majority` for
	// your read / writes as well unless you *know* you need a lesser
	// transaction level for performance reasons.
	//
	// Prior to 4.0, change streams required `majority` read concern. They don't
	// any longer, but you should still use `majority`.

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
