#!/bin/bash -x

#kill all v3io processes
sudo ps -ef | grep 'v3io_dayman\|log_server'| awk '  { print "kill -9 " $2 } ' | sudo sh

sudo pkill screen
sudo killall screen

./v3io_start.sh &

