package helpers

import (
	"math/rand"
	"time"
)

func RandomNumber(n int) int {
	rand.Seed(time.Now().UnixMicro())
	value := rand.Intn(n)
	return value
}