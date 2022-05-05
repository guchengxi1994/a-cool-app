package db

import "fmt"

var Database FishDB
var DatabasePath = "db/tmp/fishdb"

func init() {

	Database, err := Open(DatabasePath)
	if err != nil {
		fmt.Printf("err: %v\n", err)
		return
	}

	fmt.Printf("database: %v init success\n", Database)
}
