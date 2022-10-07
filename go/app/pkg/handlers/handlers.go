package handlers

import (
	"net/http"

	"github.com/tpeterson/utopia/pkg/config"
	"github.com/tpeterson/utopia/pkg/models"
	"github.com/tpeterson/utopia/pkg/render"
)

// the repository used by the handlers
var Repo *Repository

// repository is type repository
type Repository struct {
	App *config.AppConfig
}

// Creates a new respository
func NewRepo(a *config.AppConfig) *Repository {
	return &Repository{
		App: a,
	}
}

// NewHandlers - Sets the repository for the handlers
func NewHandlers(r *Repository) {
	Repo = r
}

// Home is the home page handler
func (m *Repository) Home(w http.ResponseWriter, r *http.Request) {
	render.RenderTemplate(w, "home.page.tmpl", &models.TemplateData{})

}

// About is the about page handler
func (m *Repository) About(w http.ResponseWriter, r *http.Request) {
	// perform some logic
	stringMap := make(map[string]string)
	stringMap["test"] = "Hello World"

	// send the data to the template
	render.RenderTemplate(w, "about.page.tmpl", &models.TemplateData{
		StringMap: stringMap,
	})

}
