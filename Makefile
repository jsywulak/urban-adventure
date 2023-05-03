SHELL=/bin/sh

build:
	go fmt
	go test 
	go build -o bin/att att.go
	docker build -t att .

push:
	scripts/tag-and-push.sh

bootstrap: 
	scripts/bootstrap.sh

local:
	docker run -p 8080:8080 att

test: 
	@integration_test/test.sh

up:
	@cd infra && JSII_SILENCE_WARNING_UNTESTED_NODE_VERSION=true time cdk deploy --require-approval never
	@echo "giving everything a few minutes to settle"
	@sleep 300 # give everything a moment to settle

destroy:
	@cd deploy && kubectl delete ingress ingress-att || true
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

prereqs:
	@aws --version  > /dev/null 2>&1 || echo "you need the AWS CLI installed"
	@aws sts get-caller-identity 2>&1 > /dev/null || echo "you need to configure the AWS CLI"
	@cdk --version   > /dev/null 2>&1 || echo "you need the AWS CDK installed"
	@jq --version   > /dev/null 2>&1 || echo "you need jq installed"
	@docker --version   > /dev/null 2>&1 || echo "you need docker installed"
	@kubectl help   > /dev/null 2>&1 || echo "you need kubectl installed"
	@go version   > /dev/null 2>&1 || echo "you need go installed"

clean: 
	docker rmi -f $(docker images -a -q) || true
	docker system prune -af || true
	# this is created during bootstrap step
	@aws ecr delete-repository --repository-name att | jq .

all: build up login push apply att 
