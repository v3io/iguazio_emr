#!/bin/bash


#add nginx
function add_nginx()
{
	echo "adding nginx server to the master node"
	sudo /opt/igz/spark/lib/run_nginx.sh
}
#

i=1
while [ $i -ne 0 ]; do
	sudo cat /var/log/messages | grep "Installed: spark-R-2.1.1-1.amzn1.noarch"
	i=$?
	sleep 5
done

echo "[INFO]: Creating an Hadoop directory for the iguazio user (/user/iguazio) ..."
hadoop fs -mkdir /user/iguazio
hadoop fs -chown iguazio:iguazio /user/iguazio


#change owner to zeppelin
if [ -f /etc/init/zeppelin.conf ]; then
	sudo  sed -i "s/SVC_USER=\"zeppelin\"/SVC_USER=\"iguazio\"/g" /etc/init/zeppelin.conf
	cd /etc/zeppelin/conf
	sudo mv shiro.ini.template shiro.ini
	sudo chown iguazio:iguazio -R /var/run/zeppelin/ /var/log/zeppelin/ /etc/zeppelin/ /var/lib/zeppelin/
	sudo initctl restart zeppelin
	add_nginx
fi
