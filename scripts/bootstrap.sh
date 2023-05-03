#!/bin/sh

# bootstraps the account for using this project

account=$(aws sts get-caller-identity | jq -r .Account)
region=$(aws configure get region)

find ./ -type f -exec sed -i '' -e "s/ACCOUNT_NUMBER_TOKEN/${account}/g" {} \; 2> /dev/null
find ./ -type f -exec sed -i '' -e "s/AWS_REGION_TOKEN/${region}/g" {} \; 2> /dev/null
cdk bootstrap aws://${account}/${region} 
pushd infra
npm i @aws-quickstart/eks-blueprints
popd