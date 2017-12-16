#!/bin/bash -x

#kill all v3io processes
ps -ef | grep log_server | awk '  { print "kill -9 " $2 } ' | sudo sh
ps -ef | grep daemon_config| awk '  { print "kill -9 " $2 } ' | sudo sh
sudo pkill screen
sudo killall screen

#starting log_server and v3io_daemon
sleep 2
echo "starting log_server"
/home/iguazio/igz/engine/node_runner/bin/log_server --logdir=/var/log/iguazio --log_files_size=5368709120 &
sleep 2
echo "starting v3io_daemon"

screen -dm /home/iguazio/igz/clients/v3io/bin/v3io_daemon --config /home/iguazio/igz/daemon/config/daemon_config.json
screen -wipe
