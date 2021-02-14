package models

import "go.mongodb.org/mongo-driver/bson/primitive"

// Driver ...
type Driver struct {
	ID        primitive.ObjectID `bson:"_id,omitempty"`
	FirstName string             `bson:"first_name"`
	LastName  string             `bson:"last_name"`
}
