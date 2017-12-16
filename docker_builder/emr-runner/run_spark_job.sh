#!/bin/bash

#run job
aws emr ssh --cluster-id `cat /tmp/ClusterId` --key-pair-file $HOME/.aws/emr-virginia-key.pem --command "/opt/igz/spark/lib/spark_job_example.sh"
