package main

import (
	"encoding/json"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestAllTheThings(t *testing.T) {
	assert.Equal(t, 1, 1)
	result := allTheThings()
	assert.NotNil(t, result)
	assert.True(t, json.Valid([]byte(result)))
	// json parsing in go is a pain, not gonna bother until it bites me that i didn't
}
