#!/bin/sh
 
fail () {
  echo ">>>>> test failure"
  exit 1
}


str=$(bin/att | jq '.message == "Automate all the things!"')
if [ $str != "true" ]; then
	fail
fi

tim=$(bin/att | jq '.timestamp | length == 10')
if [ $tim != "true" ] ; then
	fail
fi
