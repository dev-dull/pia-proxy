#!/bin/bash

while [ $KEEPALIVE_INTERVAL -gt 0 ]; do
  sleep $KEEPALIVE_INTERVAL
  curl -sS 'https://www.privateinternetaccess.com/site-api/get-location-info' \
    -H 'Accept: application/json' > /tmp/keepalive.json
done
