#!/bin/bash

CONFIG_FILE=/etc/tinyproxy/tinyproxy.conf
rm ${CONFIG_FILE}

# Get the internal IP address to listen on, and the tunnel IP address to direct traffic to
# The '-j' flag for the 'ip' command gets you JSON output
export TINYPROXY_Bind=$(ip -j a | jq -r '.[] | select(.ifname=="wg0").addr_info[0].local')

# TODO: Verify that none of the configuration values are empty ('Bind' is the most common offender)
env | grep -E '^TINYPROXY_' | while read "ENV_CONFIG"
do
  CONFIG_ITEM=$(echo ${ENV_CONFIG} | sed 's/TINYPROXY_//1' | grep -Eo '^[^=]+' )
  CONFIG_VALUE=$(echo ${ENV_CONFIG} | grep -Eo '[^=]+$' )  # Breaks if there's ever an '=' in the config value

  # Some configuration items can be specified more than once (e.g. Allow, Annonymous, etc.), so split them up
  # Breaks if there's ever a ',' in a configuration value that needs to stay a comma
  # TODO: This functionality is untested!!!
  if [[ -n $(echo ${CONFIG_VALUE} | grep -Eo ',' | head -n 1) ]]; then
    IFS=',' read -ra MULTI_CONFIG <<< ${CONFIG_VALUE}
    for MC in ${MULTI_CONFIG}
    do
      echo "${CONFIG_ITEM} ${MC}" >> ${CONFIG_FILE}
    done
  else
    echo "${CONFIG_ITEM} ${CONFIG_VALUE}" >> ${CONFIG_FILE}
  fi
done
