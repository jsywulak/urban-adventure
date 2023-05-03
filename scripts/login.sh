#!/bin/sh

# logs kubectl into the EKS cluster

$(aws cloudformation describe-stacks \
	--stack-name eks-blueprint \
	--region AWS_REGION_TOKEN \
	| jq -r '.Stacks[].Outputs[] | select(.OutputKey=="eksblueprintConfigCommandC5F2ABDA").OutputValue')
