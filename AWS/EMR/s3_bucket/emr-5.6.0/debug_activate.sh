#!/bin/bash

#activate or deactivate debug mode
function activate_debug()
{
  sed -i "s/\"log_level\"\: ./\"log_level\": 7/g"  /home/iguazio/igz/daemon/config/daemon_config.json
}

function deactivate_debug()
{
  sed -i "s/\"log_level\"\: ./\"log_level\": 3/g"  /home/iguazio/igz/daemon/config/daemon_config.json
}

#pass 0 for deactivate debug
#pass 1 for activate debug

if [ $1 -gt 0 ]; then
  activate_debug
else
  deactivate_debug
fi
