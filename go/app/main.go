package main

import (
	// "errors"
	"fmt"
	"net/http"
	// "text/template"
)

const portNumber = ":8080"

// main is the main function
func main() {
	http.HandleFunc("/", Home)
	http.HandleFunc("/about", About)

	fmt.Println(fmt.Sprintf("Staring application on port %s", portNumber))
	_ = http.ListenAndServe(portNumber, nil)
}
