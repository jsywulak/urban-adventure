package main

import (
	"fmt"
	"time"
)

func allTheThings() string {
	now := time.Now()
	var json = fmt.Sprintf("{\n\"message\": \"Automate all the things!\",\n\"timestamp\": \"%d\"\n}\n", now.Unix())
	return json
}

func main() {
	fmt.Print(allTheThings())
}
