package main

import "testing"

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
