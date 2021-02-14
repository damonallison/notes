package main

import (
	"context"
	"fmt"
	"log"

	"github.com/damonallison/notes/data-science/mongodb/sample/internal/mongo"
	"github.com/damonallison/notes/data-science/mongodb/sample/models"
)

//
// Compound index
//
// db.products.createIndex(
//   { first_name: 1, last_name: 1 } ,
//   { name: "first_name index" }
// }
//
// db.collection.getIndexes()
//
// Indexing strategies
//
//
func main() {
	ctx := context.Background()

	c, err := mongo.NewClient(
		mongo.WithURI("mongodb://localhost:27017"),
		mongo.WithDatabase("damon"),
		mongo.WithCollection("people"),
	)
	if err != nil {
		log.Fatal(err)
	}
	defer func() {
		err := c.Disconnect(ctx)
		if err != nil {
			log.Fatal(err)
		}
	}()

	dbs, err := c.ListDatabases(ctx)
	for _, db := range dbs {
		fmt.Printf("db: %s\n", db)
	}

	d := models.Driver{
		FirstName: "damon",
		LastName:  "allison",
	}
	d, err = c.Create(ctx, d)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("inserted: %+v\n", d)

	log.Println("done")
}
