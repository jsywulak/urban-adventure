#!/bin/sh

# calls the endpoint of the sample project and does some mild validation

fail () {
  echo ">>>>> test failure"
  exit 1
}

# look up the load balancer name and then wait for it to be available
lb=$(kubectl get ingress -o wide | tail -n 1 | awk '{print $4}' | awk -F. '{print $1}' | cut -d- -f -4)
aws elbv2 wait load-balancer-available --names $lb

host=$(kubectl get ingress | grep elb.amazonaws.com | awk '{ print $4}')

# curl the endpoint
curl $host | jq .

str=$(curl -s $host | jq '.message == "Automate all the things!"')
if [ $str != "true" ]; then
	fail
fi

tim=$(curl -s $host | jq '.timestamp | length == 10')
if [ $tim != "true" ] ; then
	fail
fi

