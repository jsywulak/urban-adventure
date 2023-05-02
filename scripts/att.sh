#!/bin/sh

# calls the endpoint of the sample project

# look up the load balancer name and then wait for it to be available
lb=$(kubectl get ingress -o wide | tail -n 1 | awk '{print $4}' | awk -F. '{print $1}' | cut -d- -f -4)
aws elbv2 wait load-balancer-available --names $lb

# curl the endpoint
curl $(kubectl get ingress | grep elb.amazonaws.com | awk '{ print $4}') | jq .
