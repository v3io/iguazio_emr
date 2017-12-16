#!/bin/bash
  /home/iguazio/igz/engine/node_runner/bin/log_server --logdir=/var/log/iguazio --log_files_size=5368709120 &
  /home/iguazio/igz/clients/v3io/bin/v3io_daemon --config /home/iguazio/igz/daemon/config/daemon_config.json &
  ps -ef | grep "v3io_daemon\|log_server"
