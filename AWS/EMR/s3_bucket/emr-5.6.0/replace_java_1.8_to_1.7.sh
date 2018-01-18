#!/bin/bash

aws s3 cp s3://igz-emr/jdk-7u80-linux-x64.tar.gz /tmp/
cd  /usr/lib/jvm
tar zxvf /tmp/jdk-7u80-linux-x64.tar.gz



#lrwxrwxrwx 1 root root  55 May 21 10:36 appletviewer -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/appletviewer
rm -f /etc/alternatives/appletviewer
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/appletviewer /etc/alternatives/appletviewer

#lrwxrwxrwx 1 root root  51 May 21 10:36 extcheck -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/extcheck
rm -f /etc/alternatives/extcheck
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/extcheck

#lrwxrwxrwx 1 root root  47 May 21 10:36 idlj -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/idlj
rm -f /etc/alternatives/idlj
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/idlj  /etc/alternatives/idlj

#lrwxrwxrwx 1 root root  46 May 21 10:36 jar -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/jar
rm -f /etc/alternatives/jar
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/jar /etc/alternatives/jar

#lrwxrwxrwx 1 root root  52 May 21 10:36 jarsigner -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/jarsigner
rm -f /etc/alternatives/jarsigner
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/jarsigner /etc/alternatives/jarsigner

#lrwxrwxrwx 1 root root  46 May 21 10:36 java -> /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java
rm -f /etc/alternatives/java
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/java /etc/alternatives/java

#lrwxrwxrwx 1 root root  48 May 21 10:36 javac -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/javac
rm -f /etc/alternatives/javac
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/javac /etc/alternatives/javac

#lrwxrwxrwx 1 root root  50 May 21 10:36 javadoc -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/javadoc
rm -f /etc/alternatives/javadoc
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/javadoc /etc/alternatives/javadoc

#lrwxrwxrwx 1 root root  48 May 21 10:36 javah -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/javah
rm -f /etc/alternatives/javah
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/javah /etc/alternatives/javah

#lrwxrwxrwx 1 root root  48 May 21 10:36 javap -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/javap
rm -f /etc/alternatives/javap
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/javap /etc/alternatives/javap

#lrwxrwxrwx 1 root root  38 May 21 10:36 java_sdk -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64
rm -f /etc/alternatives/java_sdk
ln -s /usr/lib/jvm/jdk1.7.0_80 /etc/alternatives/java_sdk

#lrwxrwxrwx 1 root root  46 May 21 10:36 java_sdk_exports -> /usr/lib/jvm-exports/java-1.8.0-openjdk.x86_64
rm -f /etc/alternatives/java_sdk_exports
ln -s /usr/lib/jvm/jdk1.7.0_80 /etc/alternatives/java_sdk_exports

#lrwxrwxrwx 1 root root  38 May 21 10:36 java_sdk_openjdk -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64
rm -f /etc/alternatives/java_sdk_openjdk
ln -s /usr/lib/jvm/jdk1.7.0_80 /etc/alternatives/java_sdk_openjdk

#lrwxrwxrwx 1 root root  46 May 21 10:36 java_sdk_openjdk_exports -> /usr/lib/jvm-exports/java-1.8.0-openjdk.x86_64
rm -f /etc/alternatives/java_sdk_openjdk_exports
ln -s /usr/lib/jvm/jdk1.7.0_80 /etc/alternatives/java_sdk_openjdk_exports

#lrwxrwxrwx 1 root root  47 May 21 10:36 jcmd -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/jcmd
rm -f /etc/alternatives/jcmd
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/jcmd /etc/alternatives/jcmd

#lrwxrwxrwx 1 root root  51 May 21 10:36 jconsole -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/jconsole
rm -f /etc/alternatives/jconsole
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/jconsole /etc/alternatives/jconsole

#lrwxrwxrwx 1 root root  46 May 21 10:36 jdb -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/jdb
rm -f  /etc/alternatives/jdb
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/jdb /etc/alternatives/jdb

#lrwxrwxrwx 1 root root  48 May 21 10:36 jdeps -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/jdeps
rm -f  /etc/alternatives/jdeps
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/jdeps  /etc/alternatives/jdeps

#lrwxrwxrwx 1 root root  47 May 21 10:36 jhat -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/jhat
rm -f /etc/alternatives/jhat
ln -s  /usr/lib/jvm/jdk1.7.0_80/bin/jhat /etc/alternatives/jhat

#lrwxrwxrwx 1 root root  48 May 21 10:36 jinfo -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/jinfo
rm -f /etc/alternatives/jinfo
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/jinfo /etc/alternatives/jinfo

#lrwxrwxrwx 1 root root  45 May 21 10:36 jjs -> /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/jjs
rm -f /etc/alternatives/jjs
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/jjs /etc/alternatives/jjs

#lrwxrwxrwx 1 root root  47 May 21 10:36 jmap -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/jmap
rm -f /etc/alternatives/jmap
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/jmap /etc/alternatives/jmap

#lrwxrwxrwx 1 root root  46 May 21 10:36 jps -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/jps
rm -f /etc/alternatives/jps
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/jps /etc/alternatives/jps

#lrwxrwxrwx 1 root root  37 May 21 10:36 jre -> /usr/lib/jvm/jre-1.8.0-openjdk.x86_64
rm -f /etc/alternatives/jre
ln -s /usr/lib/jvm/jdk1.7.0_80/jre /etc/alternatives/jre

#lrwxrwxrwx 1 root root  45 May 21 10:36 jre_exports -> /usr/lib/jvm-exports/jre-1.8.0-openjdk.x86_64
rm -f  /etc/alternatives/jre_exports
ln -s /usr/lib/jvm/jdk1.7.0_80 /etc/alternatives/jre_exports

#lrwxrwxrwx 1 root root  37 May 21 10:36 jre_openjdk -> /usr/lib/jvm/jre-1.8.0-openjdk.x86_64
rm -f  /etc/alternatives/jre_openjdk
ln -s /usr/lib/jvm/jdk1.7.0_80 /etc/alternatives/jre_openjdk

#lrwxrwxrwx 1 root root  45 May 21 10:36 jre_openjdk_exports -> /usr/lib/jvm-exports/jre-1.8.0-openjdk.x86_64
rm -f  /etc/alternatives/jre_openjdk_exports
ln -s /usr/lib/jvm/jdk1.7.0_80 /etc/alternatives/jre_openjdk_exports

#lrwxrwxrwx 1 root root  53 May 21 10:36 jrunscript -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/jrunscript
rm -f  /etc/alternatives/jrunscript
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/jrunscript /etc/alternatives/jrunscript

#lrwxrwxrwx 1 root root  52 May 21 10:36 jsadebugd -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/jsadebugd
rm -f  /etc/alternatives/jsadebugd
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/jsadebugd /etc/alternatives/jsadebugd

#lrwxrwxrwx 1 root root  49 May 21 10:36 jstack -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/jstack
rm -f /etc/alternatives/jstack
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/jstack /etc/alternatives/jstack

#lrwxrwxrwx 1 root root  48 May 21 10:36 jstat -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/jstat
rm -f /etc/alternatives/jstat
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/jstat /etc/alternatives/jstat

#lrwxrwxrwx 1 root root  49 May 21 10:36 jstatd -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/jstatd
rm -f /etc/alternatives/jstatd
ln -s  /usr/lib/jvm/jdk1.7.0_80/bin/jstatd /etc/alternatives/jstatd

#lrwxrwxrwx 1 root root  49 May 21 10:36 keytool -> /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/keytool
rm -f /etc/alternatives/keytool
ln -s  /usr/lib/jvm/jdk1.7.0_80/bin/keytool /etc/alternatives/keytool

#lrwxrwxrwx 1 root root  55 May 21 10:36 native2ascii -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/native2ascii
rm -f /etc/alternatives/native2ascii
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/native2ascii /etc/alternatives/native2ascii

#lrwxrwxrwx 1 root root  46 May 21 10:36 orbd -> /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/orbd
rm -f /etc/alternatives/orbd
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/orbd /etc/alternatives/orbd

#lrwxrwxrwx 1 root root  49 May 21 10:36 pack200 -> /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/pack200
rm -f /etc/alternatives/pack200
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/pack200 /etc/alternatives/pack200

#lrwxrwxrwx 1 root root  52 May 21 10:36 policytool -> /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/policytool
rm -f /etc/alternatives/policytool
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/policytool /etc/alternatives/policytool

#lrwxrwxrwx 1 root root  47 May 21 10:36 rmic -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/rmic
rm -f /etc/alternatives/rmic
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/rmic /etc/alternatives/rmic

#lrwxrwxrwx 1 root root  46 May 21 10:36 rmid -> /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/rmid
rm -f /etc/alternatives/rmid
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/rmid /etc/alternatives/rmid

#lrwxrwxrwx 1 root root  53 May 21 10:36 rmiregistry -> /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/rmiregistry
rm -f /etc/alternatives/rmiregistry
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/rmiregistry /etc/alternatives/rmiregistry

#lrwxrwxrwx 1 root root  52 May 21 10:36 schemagen -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/schemagen
rm -f /etc/alternatives/schemagen
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/schemagen /etc/alternatives/schemagen

#lrwxrwxrwx 1 root root  52 May 21 10:36 serialver -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/serialver
rm -f /etc/alternatives/serialver
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/serialver /etc/alternatives/serialver

#lrwxrwxrwx 1 root root  52 May 21 10:36 servertool -> /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/servertool
rm -f /etc/alternatives/servertool
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/servertool /etc/alternatives/servertool

#lrwxrwxrwx 1 root root  51 May 21 10:36 tnameserv -> /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/tnameserv
rm -f  /etc/alternatives/tnameserv
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/tnameserv  /etc/alternatives/tnameserv

#lrwxrwxrwx 1 root root  51 May 21 10:36 unpack200 -> /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/unpack200
rm -f /etc/alternatives/unpack200
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/unpack200 /etc/alternatives/unpack200

#lrwxrwxrwx 1 root root  48 May 21 10:36 wsgen -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/wsgen
rm -f  /etc/alternatives/wsgen
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/wsgen  /etc/alternatives/wsgen

#lrwxrwxrwx 1 root root  51 May 21 10:36 wsimport -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/wsimport
rm -f  /etc/alternatives/wsimport
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/wsimport /etc/alternatives/wsimport

#lrwxrwxrwx 1 root root  46 May 21 10:36 xjc -> /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/xjc
rm -f  /etc/alternatives/xjc
ln -s /usr/lib/jvm/jdk1.7.0_80/bin/xjc  /etc/alternatives/xjc


#replace links in /usr/lib/jvm directory

######################
#lrwxrwxrwx 1 root root   26 May 21 10:36 java -> /etc/alternatives/java_sdk
#lrwxrwxrwx 1 root root   32 May 21 10:36 java-1.8.0 -> /etc/alternatives/java_sdk_1.8.0
#lrwxrwxrwx 1 root root   25 May 21 10:36 java-1.8.0-openjdk -> java-1.8.0-openjdk.x86_64
#drwxr-xr-x 7 root root 4096 May 21 10:36 java-1.8.0-openjdk-1.8.0.131-2.b11.30.amzn1.x86_64
#lrwxrwxrwx 1 root root   50 May 21 10:36 java-1.8.0-openjdk.x86_64 -> java-1.8.0-openjdk-1.8.0.131-2.b11.30.amzn1.x86_64
#lrwxrwxrwx 1 root root   34 May 21 10:36 java-openjdk -> /etc/alternatives/java_sdk_openjdk
#drwxr-xr-x 8 uucp  143 4096 Apr 11  2015 jdk1.7.0_80
#lrwxrwxrwx 1 root root   21 May 21 10:36 jre -> /etc/alternatives/jre
#lrwxrwxrwx 1 root root   27 May 21 10:36 jre-1.8.0 -> /etc/alternatives/jre_1.8.0
#lrwxrwxrwx 1 root root   24 May 21 10:36 jre-1.8.0-openjdk -> jre-1.8.0-openjdk.x86_64
#lrwxrwxrwx 1 root root   54 May 21 10:36 jre-1.8.0-openjdk.x86_64 -> java-1.8.0-openjdk-1.8.0.131-2.b11.30.amzn1.x86_64/jre
#lrwxrwxrwx 1 root root   29 May 21 10:36 jre-openjdk -> /etc/alternatives/jre_openjdk
#######################

#unlink java -> /etc/alternatives/java_sdk
rm -f /usr/lib/jvm/java
ln -s  /usr/lib/jvm/jdk1.7.0_80 /usr/lib/jvm/java

#unlink java-openjdk -> /etc/alternatives/java_sdk_openjdk
rm -f /usr/lib/jvm/java-openjdk
ln -s /usr/lib/jvm/jdk1.7.0_80 /usr/lib/jvm/java-openjdk

#unlink jre -> /etc/alternatives/jre
rm -f /usr/lib/jvm/jre
ln -s /usr/lib/jvm/jdk1.7.0_80/jre /usr/lib/jvm/jre

#unlink  jre-openjdk -> /etc/alternatives/jre_openjdk
rm  -f /usr/lib/jvm/jre-openjdk
ln -s /usr/lib/jvm/jdk1.7.0_80/jre  /usr/lib/jvm/jre-openjdk



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
