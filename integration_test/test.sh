#!/bin/sh
 
fail () {
  echo ">>>>> test failure"
  exit 1
}

docker run -p 8080:8080 att &
echo "giving the container a moment to come up..."
sleep 5

curl localhost:8080 | jq .

str=$(curl -s localhost:8080 | jq '.message == "Automate all the things!"')
if [ $str != "true" ]; then
	fail
fi

tim=$(curl -s localhost:8080 | jq '.timestamp | length == 10')
if [ $tim != "true" ] ; then
	fail
fi


docker kill $(docker ps | grep /app/bin/att | awk '{print $1}' | head -n 1)
