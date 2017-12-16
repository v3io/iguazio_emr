#!/bin/bash

echo "[INFO]: starting emr cluster"
docker run \
       --detach \
       --name start_emr_cluster \
       --volume $PWD/aws/emr_install/emr-5.6.0:/emr_install \
       --volume /home/iguazio/.aws:/home/iguazio/.aws \
       --volume /tmp:/tmp \
       artifactory.iguazeng.com:6555/emr-runner:latest /start_cluster.sh &

sleep 600

echo "[INFO]: starting spark job"
docker run \
       --name run_spark_job \
       --volume $PWD/aws/emr_install/emr-5.6.0:/emr_install \
       --volume /home/iguazio/.aws:/home/iguazio/.aws \
       --volume /tmp:/tmp \
       artifactory.iguazeng.com:6555/emr-runner:latest /home/iguazio/run_spark_job.sh 

echo "[INFO]: activation terminating cluster"
docker run \
       --name terminate_emr_cluster \
       --volume $PWD/aws/emr_install/emr-5.6.0:/emr_install \
       --volume /home/iguazio/.aws:/home/iguazio/.aws \
       --volume /tmp:/tmp \
       artifactory.iguazeng.com:6555/emr-runner:latest /terminate-emr-cluster.sh
