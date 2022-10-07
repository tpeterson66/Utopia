# Go Notes

## Helpful Links

* <https://pkg.go.dev/std>
* <https://pkg.go.dev/>
* <https://developer.mozilla.org/en-US/docs/Web/javascript>
* <https://www.jsdelivr.com/>
* <https://cdnjs.com/>
* <https://developer.mozilla.org/en-US/docs/Web/CSS>

## Project Setup

The program must contain a main function which has no arguments or inputs and must not return anything.

Here is the minimal configuration to use go:

```go
package main // package declaration at the top

func main() {} // function that does not expect anything and does not return anything
```

## Variables

Variables can be set a few different ways.

```go
package main
import "fmt"

var packageVariable string = "This is a package level variable, not inside a specific function"

func main() {
  var varMain int // this sets the variable w/ type int and an empty value
  
  // set the value
  varMain = 5

  // now, varMain = 5

  // setting the variable equal to some content or output
  varOutput := exeFunction() // this sets the type matching the output type of the function and stores the output as a variable.
}

```

### Variable Naming

variables that start with a capital letter are exported at the package level and are "public" to other functions and packages. Variables that start with a lower case letter are non-exportable and are only available in the current code block.

### Variable Shadowing

This is an issue when using the same variable names, however, not understanding which variable is actually being used at a specific time in code.

```go

package main

var s = "Seven" // package variable

func main() {
  var s2 = "Six" // variable inside main()

  log.Println("s is: ", s) // Seven
  log.Println("s2 is: ", s2) // Six

  saySomething("xxx")
}

func saySomething(s3 string) (string, string) {
  log.Println("s from say something func is: ", s) // calls the package var s
}

// same function, just different setup...
func saySomething(s string) (string, string) {
  log.Println("s from say something func is: ", s) // calls variable from this function, "xxx"
}
```

This can also happen inside the main function, if you define or declare a variable by name which is used elsewhere, you need to make sure you're aware of the impact. For example, if we added `s := "eight"` to the main function, the value would be updated only when called in the main function, everywhere else would use the package value of "seven".

### Structs and Types

Using types can reduce the number of variables required for your application. This can also be used to group variables together for an intended purpose.

```go
type User struct {
  FirstName   string
  LastName    string
  PhoneNumber string
  Age         int
  BirthDate time.Time
}

// Calling the user type to create a variable
user := User {
  FirstName: "Peter",
  LastName: "Griffin",
  PhoneNumber: "555-123-1234",
  Age: 44,
  // BirthDate time.Time
}

  // call the values using user.FirstName, user.LastName, etc.
  // if value is not defined, it returns null or default value, in the case of time.Time

```

## Functions

Functions can be used to execute specific tasks. They generally take in some data, execute some code, and return some data. Since go is strict on types, the arguments coming in must match the correct type as well as the values being returned.

```go

func returnSomeData() (string, int) {
  return "someData", 10
}

// set a variable for each equal to the output. in this case, someData would be a string, count would be an int
someData, count := returnSomeData()

fmt.Println(someData, count) // someData 10
```

### Pointers

Go can reference a location in memory and update the value to a specific variable in memory vs. having to pass it back and then store it in memory after the function execution.

```go
func main()  {
var myString string // create empty string variable
myString = "Green" // set the value to green, which stores the value in memory

log.Println("myString is set to: ", myString) // print the current value = "Green"
changeUsingPointer(&myString) // call the function, see below
log.Println("After func call myString is set to: ", myString) // print the value after the function
}

func changeUsingPointer(s *string) { // expect a pointer to a string variable and reference it as s.
newValue := "Red" // store a new value as a variable in this function, could be anything
*s = newValue // update the pointer which was passed to the function w/ the new value
}

```

Notice with this method, we're not returning anything from the function or updating the value in main(), the `changeUsingPointer` function is updating the value in memory.

## Receivers on Functions

These are added to types to allow for additional functionality attached to the type.

```go
package main

import "log"

type myStruct struct { // create a new type of struct
  FirstName string
}


// add a reciver to a function (m *myStruct) attaching this function to the type. This does not require an argument, just uses a pointer to the current type or variable and references the data there.
func (m *myStruct) printFirstName() string { 
  return m.FirstName
}

func main() {
  var myVar myStruct // declare variable of type myStruct
  myVar.FirstName = "Peter" // set first name

  myVar2 := myStruct{ // declare a new var and set the value shorthand
    FirstName: "Lois",
  }


	log.Println("myVar is set to: ", myVar.printFirstName() ) // call the function attached to the type to print the first name
	log.Println("myVar2 is set to: ", myVar2.printFirstName() )
}
```

## Maps

Maps are objects. Used to store data. They're super fast... You never have to pass a pointer to a map, you only have to pass the map. This is different than other variable types where the value and reference are stored differently. Maps are stored unsorted. You must always lookup by key if you want a specific value.

```go
package main

import "log"

type User struct {
  FirstName string
  LastName string
}

func main() {
  // Do not create maps this way...
  // var myOtherMap map[string]string
  myMap := make(map[string]string) // define the structure of your map...
  myMap["dog"] = "Brian"
  myMap["cat"] = "Garfield"

  log.Println(myMap["dog"]) // Brian


  myOtherMap := make(map[string]int)
  myOtherMap["first"] = 1
  myOtherMap["second"] = 2

  log.Println(myMap["first"]) // 1

  users := make(map[string]User) // using a struct as a type (map of users)

// create a new user of type User
  pgriffin := User {
    FirstName: "Peter",
    LastName: "Griffin",
  }
  users["pgriffin"] = pgriffin // set the value of pgriffin in the map

  log.Println(users["pgriffin"].FirstName)

  // shorthand for creating lgriffin...
  users["lgriffin"] = User {
    FirstName: "Lois",
    LastName: "Griffin",
  }
  log.Println(users["lgriffin"].FirstName)

}
```

### Slices

These are arrays/lists

```go
package main

import "log"


func main() {
  var pets []string

  pets = append(pets, "fish")
  pets = append(pets, "dog")

  log.Println(pets[0])
}
```

### Decision Structures

These are if statements to evaluate some conditions and take action if a specific condition is met or not met. When using if statements, a max of two conditions should be use.

```go
package main

import "log"

func main() {
  isTrue := true // set value to true using a bool type

  if isTrue { // if value is true, since value is true, this is true.
    log.Println("isTrue: ", isTrue)
  } else { // execute if the value is not true... this would include anything else other than a bool of true.
    log.Println("isTrue: ", isTrue)
  }


  cat := "cat" // var of type string
  if cat == "cat" { // check string matches string
    log.Println("Cat is cat")
    } else {
      log.Println("Cat is not cat")
  }

  myNum := 100
  isFalse := false
  if myNum > 99 && !isFalse { // double condition and using math
    log.Println("myNum is greater than 99 and isTrue is true")
    } else if myNum < 100 && isFalse { // else if statement, max of two.
      log.Println("myNumber less than 100 and isFalse is true")
    } else {
      // no condition met
      log.Println("No condition met")
    }
}

```

Another use is switches:

```go
myVar := "turkey" // setting the value
switch myVar {
case "cat": // check if myVar == "cat"
  log.Println("myVar is set to cat") 
case "dog": // check if myVar == "dog"
  log.Println("myVar is set to dog")
case "fish": // check if myVar == "fish"
  log.Println("myVar is set to fish")
default: // if nothing matches, take this action
  log.Println("myVar is not matched")
}

```

### Loops and Ranging Over Data

```go
for i := 0; i <= 10; i++ {
  log.Println(i)
}

// ranging over a slice
animals := []string{"dog", "fish", "horse", "cat", "mouse"}
for i, animal := range animals { // return the index as i and the value as animal
  log.Println(i, animal)
}

for _, animal := range animals { // use the _ if you do not care about the index
  log.Println(animal)
}


// ranging over a map
critters := make(map[string]string)
critters["dog"] = "Brian"
critters["cat"] = "Garfield"

// range over a map and just return the values
for _, critter := range critters {
  log.Println(critter)
}

// if you want the key and value of a map
for key, value := range critters {
  log.Println(key, value)
}

// range over strings
firstLine := "Once upon a midnight dreary"

for i, l := range firstLine {
  log.Println(i, ":", l)
}

// range over maps of custom types
type User struct {
  FirstName string
  LastName  string
  Email     string
  Age       int
}
var users []User
users = append(users, User{"John", "Smith", "John@smith.com", 30})
users = append(users, User{"Jane", "Doe", "jane@doe.com", 84})
users = append(users, User{"Peter", "Griffin", "peter@familyguy.com", 30})
users = append(users, User{"Lois", "Griffin", "lois@familyguy.com", 30})

for _, user := range users {
  log.Println(user.FirstName, user.LastName, user.Email, user.Age)
}
```

### Interfaces

Interfaces are used to define how a specific item should look and can include specific methods which must exists for the type as well.

Here is one example of using an Interface; notice the inline comments to follow best practices

It is a best practice to pass a reference to the methods/functions using the interface thus requiring each of those methods of functions to use a receiver.

```go
package main

import "fmt"

type Animal interface { // define the interface and the required methods to conform
  Says() string
  NumberOfLegs() int
}

type Dog struct { // create a new type, which later, will need to be coded to support the interface
  Name  string
  Breed string
}

func main() { // create a new var using the type
  dog := Dog{
    Name:  "Samson",
    Breed: "German Shepherd",
  }

  PrintInfo(&dog) // best practice to use a reference and pass this to the receiver

}

func PrintInfo(a Animal) {
  fmt.Println("This animal says", a.Says(), "and has", a.NumberOfLegs(), "legs")
}

// add the supported methods to the type to satisfy the interface
func (d *Dog) Says() string { // should use a receiver
  return "Woof!"
}
func (d *Dog) NumberOfLegs() int { // should use a receiver
  return 4
}
```

In order for something to implement an interface, it must...
Implement the same functions as the interface in questions

### Packages

Creating custom packages;

Run `go mod init github.com/tpeterson66/myniceprogram` which creates a `go.mod` file in the project directory.

#### go.mod

```go
module github.com/tpeterson66/myniceprogram

go 1.19
```

#### Main file

```go
package main

import (
  "github.com/tpeterson66/myniceprogram/helpers"
  "log"
)

func main() {
  log.Println("Hello World!")

  var myVar helpers.SomeType
  myVar.TypeName = "SomeTypeName"
  log.Println(myVar.TypeName)
}
```

#### helpers/helpers.go

```go
package helpers

type SomeType struct {
  TypeName string
  TyperNumber int
}
```

### Channels

Used for passing information from package to another. Need more details and notes here:
<https://go.dev/tour/concurrency/2>

#### main.go

```go
package main

import (
  "log"
  "github.com/tpeterson66/myniceprogram/helpers"
)

const numberPool = 20 // const value

func CalculateValue(intChan chan int) {
  randomNumber := helpers.RandomNumber(numberPool) // calling the RandomNumber function from helpers
  intChan <- randomNumber // send random number to channel
}

func main() {
  intChan := make(chan int) // channel that can only hold int(s)
  defer close(intChan) // when finished running, close the channel

  go CalculateValue(intChan) // fire off a new go routine (concurrent) passing the intChan channel

  num := <-intChan // wait for a response to the channel 
  log.Println(num) // print it out
}
```

#### helpers.go

```go
package helpers

import (
  "math/rand"
  "time"
)

func RandomNumber(n int) int { // new function expecting an int and returning an int
  rand.Seed(time.Now().UnixMicro()) // seed the random function
  value := rand.Intn(n) // create random value
  return value // return it
}
```

### Reading and Writting JSON

```go
package main

import (
  "encoding/json"
  "fmt"
  "log"
)

// created to match json elements to a struct property
type Person struct {
  First_name string `json:"first_name"`
  Last_name  string `json:"last_name"`
  Hair_color string `json:"hair_color"`
  Has_dog    bool   `json:"has_dog"`
}

func main() {
  // Sample JSON, array of objects...
  myJson := `
  [
    {
      "first_name": "Peter",
      "last_name": "Griffin",
      "hair_color": "black",
      "has_dog": true
    },
    {
      "first_name": "Lois",
      "last_name": "Griffin",
      "hair_color": "red",
      "has_dog": false
    }
  ]`

  // unmarshalled = data before conversion
  var unmarshalled []Person

  // use json.Unmarshal to convert the json to a struct, requires a type to be defined and a variable w/ the type of the struct
  err := json.Unmarshal([]byte(myJson), &unmarshalled)

  if err != nil { // check for errors
    log.Println("Error unmarshalling json", err) // log error is present
  }

  log.Printf("unmarshalled: %v", unmarshalled) // print json struct to screen

  // write JSON from a struct

  var mySlice []Person // create a new slice of data to form the array of the JSON

  // add some structs to the array...
  var m1 Person
  m1.First_name = "Wally"
  m1.Last_name = "West"
  m1.Hair_color = "red"
  m1.Has_dog = false

  mySlice = append(mySlice, m1)

  var m2 Person
  m2.First_name = "Diana"
  m2.Last_name = "Prince"
  m2.Hair_color = "black"
  m2.Has_dog = false

  mySlice = append(mySlice, m2)

  // convert the slice to json using json.MarshalIndent. MarshalIndent prints a formatted value vs. a full string
  newJson, err := json.MarshalIndent(mySlice, "", "    ")
  if err != nil { // check for error
    log.Println("error marshalling", err)
  }

  fmt.Println(string(newJson)) // print the value of the formatted JSON value
}
```

### Writting Tests in Go


Export the results of the tests to html to see test coverage using `go test -coverprofile=coverage.out && go tool cover -html=coverage.out`

```go
package main

import "testing" // built in package

func TestDivide(t *testing.T) {
  _, err := divide(10.0, 1.0)
  if err != nil {
    t.Error("Got an error when we should not have...")
  }
}
func TestBadDivide(t *testing.T) {
  _, err := divide(10.0, 0)
  if err == nil {
    t.Error("Did not get an error when we should've gotten an error!")
  }
}
```

```go
// table test

var tests = []struct {
  name     string
  dividend float32
  divisor  float32
  expected float32
  isErr    bool
}{
  {"valid-data", 100.0, 10.0, 10.0, false},
  {"invalid-data", 100.0, 0.0, 0.0, true},
}

func TestDivision(t *testing.T) {
  for _, tt := range tests {
    got, err := divide(tt.dividend, tt.divisor)
    if tt.isErr {
      if err == nil {
      t.Error("expected an error, did not get one...")
    }
    } else {
      if err != nil {
        t.Error("Did not expect an error, but got one...")
      }
    }

    if got != tt.expected {
      t.Errorf("Expected %f but got %f", tt.expected, got)
    }
  }
}
```

### Standard HTTP Listener

```go
package main

import (
	"fmt"
	"net/http"
)

func main() {
	// handle http requests/responses
	// new function using net/http.HandleFunc which takes a path:string, Response Writter, and a pointer to the request (not the actual request...)
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request){
		n, err := fmt.Fprintf(w, "Hello World") // fmt.Fprintf - takes the writter (w in this case) and the value we want to write, hello world in this example. Returns the number of bytes written and an error.
		if err != nil { // check for no errors, if error, print err - need better error handling
			fmt.Println(err)
		}

		fmt.Println(fmt.Sprintf("Number of bytes written: %d", n)) // print the output to the console for a log.
	})
	// start the server on 4001
	_ = http.ListenAndServe(":4001", nil) // returns an error, using the _ up front ignores the output.
}
```

### Working with Templates and Local Caching

Simple example rendering templates, which requires some files to get started...

#### base.layout.tmpl

```go
{{define "base"}} // define the type of template, this is a base template, or base index.html
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">

    {{block "css" .}} // define a block for custom css
    {{end}}
  </head>
  <body>
   {{block "content" .}} // define a block for dynamic content
   {{end}}

   {{block "js" .}} // define a block for custom js.
   {{end}}
  </body>
  </html>
{{end}}
```
#### home.page.tmpl
```go
{{template "base" .}} // call the layout template which will be used

{{define "content"}} // provide data for the content block
  <div class="container">
    <div class="row">
      <div class="col">
        <h1>This is the home page</h1>
        <p>This is some text...</p>
      </div>
    </div>
  </div>
{{end}}
```

### Rendering Templates

```go
// RenderTemplate renders templates using html/template
func RenderTemplateTest(w http.ResponseWriter, tmpl string) {
	parsedTemplate, _ := template.ParseFiles("./templates/" + tmpl, "./templates/base.layout.tmpl") // calls in the files required to render the template
	err := parsedTemplate.Execute(w, nil) // parse the template calling the execute function, write to the response writer the results or capture the error.
	if err != nil { // error checking...
		fmt.Println("error parsing template", err)
		return
	}
}
```

### Rendering Templates with a Local Cache

```go

// variable to hold the template cache
var tc = make(map[string]*template.Template) // create a map of templates using the template pointer

func RenderTemplate(w http.ResponseWriter, t string) { // function taking in the writer and the template
	var tmpl *template.Template // var ref to template
	var err error // var for any errors

	// check to see if we already have the template in cache
	_, inMap := tc[t] // check if template is in cache
	if !inMap { // if the template is in cache, inMap will be true, else, false
		// need to create template, template is not in map.
		log.Println("creating template and adding to cache")
		err = createTemplateCache(t) // call the function to create the template and push template to map
		if err != nil { // error handling
			log.Println(err)
		}
		
	} else {
		// we have the template in the cache
		log.Println("using cached template")
	}

	tmpl = tc[t] // update the tmpl variable pointer for the response
	err = tmpl.Execute(w, nil) // execute the template and send response to response writer
	if err != nil { // error handling
		log.Println(err)
	}
}

func createTemplateCache(t string) error {
	templates := []string{ // used to pass multiple values to ParseFiles, need an entry for every layout going to be used.
		fmt.Sprintf("./templates/%s", t),
		"./templates/base.layout.tmpl",
	}
	// parse the template
	tmpl, err := template.ParseFiles(templates...) // parse the templates using layouts and template files

	if err != nil { // error handling
		return err
	}

	// add template to cache
	tc[t] = tmpl // push update template to map

	return nil // return no errors if completed successfully
}
```