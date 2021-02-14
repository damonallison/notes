package mongo

import (
	"context"
	"time"

	"github.com/damonallison/notes/data-science/mongodb/sample/models"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"go.mongodb.org/mongo-driver/mongo/readpref"
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
	driver.ID = primitive.NilObjectID
	res, err := c.coll.InsertOne(ctx, driver)
	if err != nil {
		return models.Driver{}, err
	}
	driver.ID = res.InsertedID.(primitive.ObjectID)
	return driver, nil
}
