SHELL=/bin/sh

build:
	go fmt
	go test 
	go build -o bin/att att.go
	docker build -t att .

local:
	docker run -p 8080:8080 att

test: 
	@integration_test/test.sh

up:
	@cd infra && JSII_SILENCE_WARNING_UNTESTED_NODE_VERSION=true time cdk deploy --require-approval never
	@sleep 300 # give everything a moment to settle

destroy:
	@cd deploy && kubectl delete service ingress-att || true
	@cd deploy && kubectl delete service backend-service || true
	@cd deploy && kubectl delete deployment att || true
	@cd infra && JSII_SILENCE_WARNING_UNTESTED_NODE_VERSION=true time cdk destroy --force

login:
	scripts/login.sh

apply:
	@cd deploy && kubectl apply -f deployment.yml
	@sleep 15
	@cd deploy && kubectl apply -f service.yml
	@sleep 15
	@cd deploy && kubectl apply -f lb.yml
	@sleep 15

att:
	scripts/att.sh

all: build up login apply att destroy
