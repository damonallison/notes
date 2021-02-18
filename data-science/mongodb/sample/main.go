package main

import (
	"context"
	"fmt"
	"log"
	"strconv"
	"time"

	"github.com/shipt/damon/mongodb/internal/db"
	"github.com/shipt/damon/mongodb/internal/models"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

// Driver ...
type Driver struct {
	ID             primitive.ObjectID `json:"id" bson:"_id,omitempty"`
	FirstName      string             `json:"first_name" bson:"first_name"`
	LastName       string             `json:"last_name" bson:"last_name"`
	CreatedAt      time.Time          `json:"created_at" bson:"created_at`
	Certifications []Certification    `json:"certifications" bson:"certifications"`
}

// Certification ...
type Certification struct {
	Name   string `json:"name" bson:"name"`
	Metros []int  `json:"metros,omitempty" bson:"metros,omitempty"`
}

func main() {
	ctx := context.Background()

	// For sharded clusters, connect to the `mongos` instance.
	db, err := db.NewClient(
		db.WithURI("mongodb://localhost:27017"),
		db.WithDatabase("shipt"),
		db.WithCollection("drivers"))

	if err != nil {
		log.Fatal(err)
	}

	defer func() {
		err := db.Disconnect(ctx)
		if err != nil {
			log.Fatal(err)
		}
	}()

	go watch(ctx, db)
	createdAt := time.Now()

	d, err := db.Create(ctx, models.Driver{
		FirstName: "damon",
		LastName:  "allison",
		Certifications: []models.Certification{
			{
				Name: models.CertNameAlcohol,
				Metadata: []models.CertificationMetadata{
					{
						Key:   "license_state",
						Value: "MN",
					},
					{
						Key:   "license_number",
						Value: "X234432234232344",
					},
				},
				CreatedAt: createdAt,
			},
		},
		CreatedAt: createdAt,
	})
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("created : %+v\n", d)

	if err != nil {
		log.Fatal(err)
	}

	log.Println("--- Finding drivers named 'damon'")
	drivers, err := db.FindByFirstName(ctx, "damon")
	if err != nil {
		log.Fatal(err)
	}
	for _, d := range drivers {
		log.Printf("driver : %+v\n", d)
	}

	log.Printf("--- Finding %s certified drivers\n", models.CertNameAlcohol)
	drivers, err = db.FindByCertName(ctx, models.CertNameAlcohol)
	for _, d := range drivers {
		log.Printf("driver : %+v\n", d)
	}

	log.Println("--- Updating driver")
	d = drivers[len(drivers)-1]
	d.FirstName += " - updated"

	d, err = db.Update(ctx, d)
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("updated driver %+v", d)

	log.Println("--- Deleting driver")
	db.Delete(ctx, d)

	log.Println("--- Creating drivers")
	// _, err = createDrivers(db, 10000)
	if err != nil {
		log.Fatal(err)
	}
	log.Println("--- deleting all drivers")
	clean(ctx, db)

	log.Println("--- waiting for change stream")
	time.Sleep(30 * time.Second)
	log.Print("--- Done\n")
}

func createDrivers(db *db.Client, n int) ([]models.Driver, error) {
	drivers := make([]models.Driver, n)
	for i := 0; i < n; i++ {
		now := time.Now()
		drivers[i] = models.Driver{
			FirstName: fmt.Sprintf("first %d", i),
			LastName:  fmt.Sprintf("last %d", i),
			CreatedAt: now,
			Certifications: []models.Certification{
				{
					Name: models.CertNameAlcohol,
					Metadata: []models.CertificationMetadata{
						{
							Key:   "license_state",
							Value: "MN",
						},
						{
							Key:   "license_number",
							Value: strconv.Itoa(i),
						},
					},
					CreatedAt: now,
				},
			},
		}
	}
	return db.CreateMany(context.Background(), drivers...)
}

func clean(ctx context.Context, db *db.Client) error {
	drivers, err := db.FindAll(ctx)
	if err != nil {
		return err
	}
	return db.Delete(ctx, drivers...)
}

// Sets up a change stream
//
// Mongo supports "resume tokens", which allows you to start a change stream
// from a resume point (see `startAfter`)
//
// IMPORTANT: The oplog must have enough history to locate the operation
// associated with the resume token.
func watch(ctx context.Context, db *db.Client) error {
	c := make(chan bson.D, 0)
	done := make(chan error, 0)

	go db.Watch(context.Background(), c, done)

	for {
		select {
		case change := <-c:
			fmt.Printf("received change: %+v\n", change)
		case err := <-done:
			fmt.Printf("change stream closed")
			if err != nil {
				log.Fatalf("change stream error: %v", err)
			}
			return nil
		}
	}
}
