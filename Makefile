build:
	go fmt
	go build -o bin/att att.go

run:
	go run att.go

test:
	go test 

int: build
	integration_test/test.sh

all: test run build 