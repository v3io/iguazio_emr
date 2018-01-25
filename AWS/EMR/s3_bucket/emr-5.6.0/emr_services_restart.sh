#!/bin/bash

initctl restart hadoop-mapreduce-historyserver
initctl restart hadoop-yarn-timelineserver
initctl restart hadoop-yarn-resourcemanager
initctl restart hadoop-kms
initctl restart hadoop-httpfs
initctl restart hadoop-yarn-proxyserver
initctl restart hadoop-hdfs-namenode
initctl restart hadoop-yarn-timelineserver
initctl restart hadoop-yarn-resourcemanager
initctl restart hadoop-yarn-proxyserver
initctl restart hadoop-hdfs-datanode
initctl restart hadoop-yarn-nodemanager
