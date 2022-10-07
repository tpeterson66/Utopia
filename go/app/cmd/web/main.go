package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/tpeterson/utopia/pkg/config"
	"github.com/tpeterson/utopia/pkg/handlers"
	"github.com/tpeterson/utopia/pkg/render"
)

const portNumber = ":4001"

// main is the main application function
func main() {
	var app config.AppConfig

	tc, err := render.CreateTemplateCache()
	if err != nil {
		log.Fatal("Cannot create template cache")
	}

	app.TemplateCache = tc
	app.UseCache = true

	render.NewTemplate(&app)

	repo := handlers.NewRepo(&app)
	handlers.NewHandlers(repo)


	// http.HandleFunc("/", handlers.Repo.Home)
	// http.HandleFunc("/about", handlers.Repo.About)

	// Write to console:
		fmt.Println(fmt.Sprintf("Starting application on port %s", portNumber))
		srv := &http.Server{
			Addr: portNumber,
			Handler: routes(&app),
		}
		err = srv.ListenAndServe()
		log.Fatal(err)
	
	// start the server on 4001
	// _ = http.ListenAndServe(portNumber, nil) // returns an error, using the _ up front ignores the output.
}