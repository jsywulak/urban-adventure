#!/bin/sh

# bootstraps the account for using this project

account=$(aws sts get-caller-identity | jq -r .Account)
region=$(aws configure get region)

files=(./deploy/deployment.yml ./scripts/tag-and-push.sh ./scripts/login.sh)
for file in $files; do
	sed -i '' -e "s/ACCOUNT_NUMBER_TOKEN/${account}/g" <file>
	sed -i '' -e "s/AWS_REGION_TOKEN/${region}/g" <file>
done

JSII_SILENCE_WARNING_UNTESTED_NODE_VERSION=true cdk bootstrap aws://${account}/${region} 

pushd infra
npm i @aws-quickstart/eks-blueprints
popd

# create the ECR repo here instead of via cdk, since you can't delete it via cdk
aws ecr create-repository --repository-name att | jq .
