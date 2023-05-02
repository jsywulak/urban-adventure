package main

import (
	"fmt"
	"net/http"
	"time"
)

func allTheThings() string {
	now := time.Now()
	var json = fmt.Sprintf("{\n\"message\": \"Automate all the things!\",\n\"timestamp\": \"%d\"\n}\n", now.Unix())
	return json
}

// func main() {
// 	fmt.Print(allTheThings())
// }

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, allTheThings())
}
