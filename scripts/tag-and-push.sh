#!/bin/sh

# tags and pushes the image to the ECR repo
aws ecr get-login-password \
	--region AWS_REGION_TOKEN \
	| docker login \
	--username AWS \
	--password-stdin ACCOUNT_NUMBER_TOKEN.dkr.ecr.AWS_REGION_TOKEN.amazonaws.com

docker tag att:latest ACCOUNT_NUMBER_TOKEN.dkr.ecr.AWS_REGION_TOKEN.amazonaws.com/att:latest
docker push ACCOUNT_NUMBER_TOKEN.dkr.ecr.AWS_REGION_TOKEN.amazonaws.com/att:latest