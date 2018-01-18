#!/bin/bash
#aggregate the all v3io statistics
tar zcvf /tmp/logs.v3io.tar.gz /dev/shm/*stats* /dev/shm/daemon_shared_read* /var/log/iguazio/*.log /var/crash/*
