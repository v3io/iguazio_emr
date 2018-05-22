#!/bin/bash
	#starting log_server and v3io_daemon
	sudo su - iguazio -c "nohup /home/iguazio/igz/engine/node_runner/bin/log_server -s /var/log/iguazio/logserver.socket -v -d /var/log/iguazio -o 10000000 -l 10 & "
	sleep 2
	
	sudo su - iguazio -c "nohup /home/iguazio/igz/clients/v3io/bin/v3io_dayman --config /home/iguazio/igz/daemon/config/dayman_config.json &"
	logger -T "running_iguazio_services done"
	ps -ef | grep "v3io_daemon\|log_server"
