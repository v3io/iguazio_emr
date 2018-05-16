#!/bin/bash

ClusterId=`cat /tmp/ClusterId`

echo "terminating the cluster <$ClusterId>"
aws  emr terminate-clusters --cluster-ids $ClusterId
