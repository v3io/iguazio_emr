#!/bin/bash
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/iguazio/igz/clients/nginx/lib
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/iguazio/igz/clients/v3io/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/igz/spark/lib
nginx_tmpl=/home/iguazio/igz/clients/nginx/conf/nginx_multi_workers.conf
temp_file=/tmp/nginx.conf
conf_file=/home/iguazio/igz/clients/nginx/conf/nginx.conf

NODE_IP=`cat /etc/data_node_ip` 

echo "load_module /home/iguazio/igz/clients/nginx/lib/ngx_http_v3io_module.so;" > $temp_file
cat $nginx_tmpl | grep -v load_module >> $temp_file
cat $temp_file | sed "s/127.0.0.1/$NODE_IP/g" | sed 's/8443/8445/g' > $conf_file

#if limits.conf has default parameters use this limit 
ulimit -n 94000

[ -d /var/log/iguazio/nginx/logs ] || mkdir -p /var/log/iguazio/nginx/logs
/home/iguazio/igz/clients/nginx/bin/nginx -p /var/log/iguazio/nginx -c $conf_file
