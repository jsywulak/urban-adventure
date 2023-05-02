#!/bin/sh

# logs kubectl into the EKS cluster

$(aws cloudformation describe-stacks \
	--stack-name eks-blueprint \
	--region eu-west-2 \
	| jq -r '.Stacks[].Outputs[] | select(.OutputKey=="eksblueprintConfigCommandC5F2ABDA").OutputValue')
