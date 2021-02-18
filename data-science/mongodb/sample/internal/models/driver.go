package models

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

const (
	// CertNameAlcohol ...
	CertNameAlcohol = "alcohol"
)

// Driver ...
type Driver struct {
	ID             primitive.ObjectID `bson:"_id,omitempty"`
	FirstName      string             `bson:"first_name,omitempty"`
	LastName       string             `bson:"last_name,omitempty"`
	Certifications []Certification    `bson:"certifications,omitempty"`
	CreatedAt      time.Time          `bson:"created_at,omitempty"`
}

// Certification ...
type Certification struct {
	Name      string                  `bson:"name,omitempty"`
	Metadata  []CertificationMetadata `bson:"metadata,omitempty"`
	CreatedAt time.Time               `bson:"created_at,omitempty"`
}

// CertificationMetadata ...
type CertificationMetadata struct {
	Key   string `bson:"key"`
	Value string `bson:"value"`
}
