#!/bin/sh
#
# this script will prettify the json files in this directory
# 
# this will compress JSON into one line:
#       cat $i | jq -c -S '.'
#
# this will prettify and sort JSON, similar to this script:
#       cat $i | jq -S '.'

for i in *.json
do
        python -mjson.tool $i > tmp.json && mv tmp.json $i
done
