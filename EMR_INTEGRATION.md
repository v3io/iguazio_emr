Installation v3io on EMR.
=========================

1 Create EMR cluster with spark 1.6.2 - emr 4.8.2
2 Open in the security group port 22 for ssh
3 login into EMR 
4 Install docker:
    4.1 install docker service 
    4.2 activate docker service 
5 Install v3io daemon
6 Point v3io daemon to node
7 Config spark daemon :

7 Access from the public domain:

Name of interface URL

- YARN ResourceManager	http://master-public-dns-name:8088/
- YARN NodeManager		http://slave-public-dns-name:8042/
- Hadoop HDFS NameNode	http://master-public-dns-name:50070/
- Hadoop HDFS DataNode	http://slave-public-dns-name:50075/
- Spark HistoryServer	http://master-public-dns-name:18080/
- Zeppelin				http://master-public-dns-name:8890/
- Hue					http://master-public-dns-name:8888/
- Ganglia				http://master-public-dns-name/ganglia/
- HBase UI				http://master-public-dns-name:16010/


