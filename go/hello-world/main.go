package main

import "fmt"

type Animal interface {
	Says() string
	NumberOfLegs() int
}

type Dog struct {
	Name  string
	Breed string
}

func main() {
	dog := Dog{
		Name:  "Samson",
		Breed: "German Shepherd",
	}

	PrintInfo(&dog) // best practice to use a reference and pass this to the receiver

}

func PrintInfo(a Animal) {
	fmt.Println("This animal says", a.Says(), "and has", a.NumberOfLegs(), "legs")
}

func (d *Dog) Says() string { // should use a receiver
	return "Woof!"
}
func (d *Dog) NumberOfLegs() int { // should use a receiver
	return 4
}