#!/bin/bash

IGZ_EMR_VERSION=5.12.1

function change_ulimit()
{
  local tmp_limit=/tmp/limits.conf
  sudo cat /etc/security/limits.conf > $tmp_limit
  sudo echo "iguazio hard nofile 94000" >> $tmp_limit 
  sudo echo "iguazio soft nofile 94000" >> $tmp_limit
  sudo echo "iguazio hard noproc 64000" >> $tmp_limit 
  sudo echo "iguazio soft noproc 64000" >> $tmp_limit 
  sudo mv $tmp_limit /etc/security/limits.conf 
  sudo chmod 644 /etc/security/limits.conf
  sudo chown root:root /etc/security/limits.conf
  logger -T "change_ulimit done"
}

function sysctl_update()
{
  #change swappines policy
  sudo sysctl "vm.swappiness=10"
  #enable coredump
  sudo sysctl kernel.core_pattern="|/opt/igz/spark/lib/core.sh %e %p %h %t"
  #decrease timeout
  sudo sysctl "net.ipv4.tcp_fin_timeout=30"
  logger -T "sysctl_update done"
}

function create_user_iguazio()
{
  #create user
  sudo groupadd -g 1000 iguazio
  sudo useradd -g 1000 -u 1000 iguazio

  #copy ssh keys
  sudo mkdir  /home/iguazio/.ssh
  sudo cp /home/hadoop/.ssh/authorized_keys /home/iguazio/.ssh/
  sudo chown iguazio:iguazio -R /home/iguazio/.ssh/
  sudo chmod 600 /home/iguazio/.ssh/authorized_keys

  #add iguazio to sudoers
  sudo cp /etc/sudoers /tmp
  sudo chmod 666 /tmp/sudoers
  sudo echo "iguazio ALL=(ALL) NOPASSWD: ALL" >> /tmp/sudoers
  sudo chmod 440 /tmp/sudoers
  sudo mv /tmp/sudoers /etc/sudoers

  #create data and log directories
  sudo mkdir -p /var/log/iguazio
  sudo mkdir -p /mnt/data
  sudo chown -R iguazio:iguazio /var/log/iguazio /mnt/data

  #define directory for the coredump files
  sudo mkdir /var/crash
  chmod 777 /var/crash
  logger -T "create_user_iguazio done"
}

function install_daemon_config()
{
  # Install docker
  sudo mkdir -p /home/iguazio/igz/daemon/config

cat << EOF > /tmp/daemon_config.json
  {
      "daemon": {
          "pidfile": "/tmp/iguazio_daemon.pid"
      },
      "addresses": {
          "cluster_endpoints": [
    {
      "endpoint":  "tcp://$igz_data_node_ip:1234"
    }
    ],
          "daemon_endpoint": "tcp://0.0.0.0:20000"
      },
      "resources": {
          "read_buffer_size_mb": 2047,
          "io_depth": 4096,
          "error_jobs_num": 4096
      },
      "log": {
          "logs_dir_path": "/var/log/iguazio",
          "use_log_server": false,
          "log_level": 3,
          "log_server_domain_socket": "/tmp/domain_listener_ipc_namespace.1234"
      }
  }
EOF

  sudo mv /tmp/daemon_config.json /home/iguazio/igz/daemon/config/daemon_config.json

  cat << EOF > /tmp/dayman_config.json
{
  "num_workers": 2,
  "max_channel_inactivity_period_seconds": 180,
  "shmem_posix_permission": "0660",
  "max_inflight_requests": 4096,
  "cdi": {
    "listen_addr": "0.0.0.0:1967"
  },
  "job_block_allocator": {
    "mode": "per-worker",
    "heaps": [
      {
        "kind": "mempool",
        "block_size_bytes": 5120,
        "num_blocks": 5000
      },
      {
        "kind": "mempool",
        "block_size_bytes": 20480,
        "num_blocks": 2000
      },
      {
        "kind": "mempool",
        "block_size_bytes": 73728,
        "num_blocks": 500
      },
      {
        "kind": "mempool",
        "block_size_bytes": 286720,
        "num_blocks": 500
      },
      {
        "kind": "mempool",
        "block_size_bytes": 563200,
        "num_blocks": 500
      },
      {
        "kind": "mempool",
        "block_size_bytes": 1126400,
        "num_blocks": 500
      },
      {
        "kind": "mempool",
        "block_size_bytes": 2150400,
        "num_blocks": 500
      },
      {
        "kind": "boost",
        "size_bytes": 536870912
      }
    ]
  },
  "logger": {
    "mode": "log_server",
    "severity": "debug",
    "path": "/var/log/iguazio/"
  },
  "paths": {
    "fifo": "/var/opt/iguazio/dayman/fifo",
    "uds": "/var/opt/iguazio/dayman/uds",
    "pidfile": "/var/opt/iguazio/dayman/pid/dayman.pid"
  },
  "cluster": {
     "uris": [
EOF

  arr=[]
  count_id=0
  for i in `echo $igz_data_node_ip| tr ',' ' '`;do  
      echo "{\"uri\": \"tcp://$i:1234\"}," >> /tmp/nodes.tmp 
      ((count_id++))
  done

  cat /tmp/nodes.tmp |  sed '$ s/.$//' >> /tmp/dayman_config.json
  echo "     ]" >> /tmp/dayman_config.json
  echo "  }" >> /tmp/dayman_config.json
  echo "}" >> /tmp/dayman_config.json

  sudo mkdir -p /home/iguazio/igz/dayman/config
  sudo cp /tmp/dayman_config.json /home/iguazio/igz/dayman/config
  sudo mv /tmp/dayman_config.json /home/iguazio/igz/daemon/config/dayman_config.json

  sudo mkdir -p /var/log/iguazio/dayman 
  sudo mkdir -p /var/opt/iguazio/dayman/{pid,fifo,uds,log}
  sudo chmod -R 777 /var/opt/iguazio /var/log/iguazio

  sudo mkdir -p /opt/iguazio/bigdata/conf
  sudo chown iguazio:iguazio -R  /home/iguazio/
  logger -T "install_daemon_config done"
}

function copy_artifacts()
{
  # Copy JAR files
  IGZ_TMP=/tmp/igz/spark/lib
  mkdir -p $IGZ_TMP
  logger -T "$(date) Copying artifacts from $s3_bucket_dir to $IGZ_TMP" 
  #TODO TBD change the common place to different paths.
  #ask for symbol links.

  aws s3 cp --recursive $s3_bucket_dir/ $IGZ_TMP/
  sudo mv /tmp/igz /opt/igz
  logger -T "copy_artifacts done"
}

function install_packages()
{
  sudo yum install  python-devel libffi-devel git python-pip docker lz4 screen "development tools" -y
  sudo rpm -ivh /opt/igz/spark/lib/*.rpm
  sudo rm -f /opt/igz/spark/lib/*.rpm
  logger -T "install_packages done"
}

function running_iguazio_services()
{
  sudo cp  /home/iguazio/igz/bigdata/conf/v3io-dayman.conf /opt/iguazio/bigdata/conf/v3io.conf
  sudo chmod 777 /opt/iguazio/bigdata/conf/v3io.conf
  # Run iguazio Data Platform services, including the v3io daemon
  sudo su - iguazio -c "/home/iguazio/igz/engine/node_runner/bin/log_server -s /var/log/iguazio/logserver.socket -v -d /var/log/iguazio -o 10000000 -l 10 "
  sudo su - iguazio -c "/home/iguazio/igz/clients/v3io/bin/v3io_dayman --config /home/iguazio/igz/daemon/config/dayman_config.json &"
  logger -T "running_iguazio_services done"
}

function presto_installation()
{
  v3io_properties="/tmp/v3io.properties"
  logger -T "[INFO]: presto installation"
  sudo mkdir -p /usr/lib/presto/plugin/v3io
  sudo mkdir -p /usr/lib/presto/plugin/hive-hadoop2
  sudo mv /opt/igz/spark/lib/v3io-presto_2.11-1.5.0.jar /usr/lib/presto/plugin/v3io/
  sudo ln -s  /opt/igz/spark/lib/*.jar /usr/lib/presto/plugin/v3io/
  sudo ln -s  /opt/igz/spark/lib/*.jar /usr/lib/presto/plugin/hive-hadoop2/
  sudo mkdir -p /etc/presto/conf/catalog
  sudo echo "connector.name=v3io" > $v3io_properties
  sudo echo "v3io.num.splits.for.path=36" >> $v3io_properties
  sudo chown presto:presto -R /usr/lib/presto/plugin/v3io
  sudo mv $v3io_properties  /etc/presto/conf/catalog/v3io.properties
}

function cahnge_tenant()
{
  echo "going to change tenant $tenant_name and container  $container_name"
  aws s3 cp $s3_bucket_dir/configure_tenant.py /tmp/configure_tenant.py
  sudo chmod 0777 /tmp/configure_tenant.py
  sudo /tmp/configure_tenant.py -container $container_name -tenant $tenant_name
  sudo rm /tmp/configure_tenant.py
}

function main()
{
    local igz_data_node_ip=$1
    echo "$igz_data_node_ip" > /tmp/data_node_ip
    sudo cp "$igz_data_node_ip" /etc/data_node_ip
    #TODO Make it secure ... .
    if [ -z $igz_data_node_ip ]; then
        logger -T "[ERROR]: The iguazio data-node argument (\$1) is missing."
        exit
    fi

    local s3_bucket_dir=$2
    if [ -z $s3_bucket_dir ]; then
        logger -T "[ERROR]: The S3-bucket installation-directory argument (\$2) is missing."
        exit
    fi

    local container_name=$3
    if [ -z $container_name ]; then
        logger -T "[ERROR]: The default container name (\$3) is missing."
        exit
    fi

      local tenant_name=$4
    if [ -z $tenant_name ]; then
        logger -T "[ERROR]: The tenant name (\$4) is missing."
        exit
    fi
    copy_artifacts
    create_user_iguazio
    install_daemon_config
    install_packages
    running_iguazio_services
    sysctl_update
    change_ulimit
    presto_installation
    cahnge_tenant
 

    # Copy post-installation artifacts and change permissions
    sudo mkdir /home/iguazio/igz/bigdata/libs
    sudo chown -R iguazio:iguazio /home/iguazio/
    sudo chmod 755 /opt/igz/spark/lib/*.sh
    . /opt/igz/spark/lib/post_install_${IGZ_EMR_VERSION}.sh &
    sudo ln -s /opt/igz/spark/lib/* /home/iguazio/igz/bigdata/libs/
    logger -T "Iguazio installation done"
}

# Execute the script
main $@
