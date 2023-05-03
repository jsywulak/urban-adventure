#!/bin/sh

# bootstraps the account for using this project

account=$(aws sts get-caller-identity | jq -r .Account)
region=$(aws configure get region)

echo "account number: ${account}"
echo "region: ${region}"

sed -i '' -e "s/ACCOUNT_NUMBER_TOKEN/${account}/g" ./deploy/deployment.yml
sed -i '' -e "s/AWS_REGION_TOKEN/${region}/g" ./deploy/deployment.yml

sed -i '' -e "s/ACCOUNT_NUMBER_TOKEN/${account}/g" ./scripts/tag-and-push.sh
sed -i '' -e "s/AWS_REGION_TOKEN/${region}/g" ./scripts/tag-and-push.sh

sed -i '' -e "s/ACCOUNT_NUMBER_TOKEN/${account}/g" ./scripts/login.sh
sed -i '' -e "s/AWS_REGION_TOKEN/${region}/g" ./scripts/login.sh

sed -i '' -e "s/ACCOUNT_NUMBER_TOKEN/${account}/g" ./infra/bin/infra.ts
sed -i '' -e "s/AWS_REGION_TOKEN/${region}/g" ./infra/bin/infra.ts

JSII_SILENCE_WARNING_UNTESTED_NODE_VERSION=true cdk bootstrap aws://${account}/${region} 

pushd infra
npm i @aws-quickstart/eks-blueprints
popd

# create the ECR repo here instead of via cdk, since you can't delete it via cdk
aws ecr create-repository --repository-name att | jq .
