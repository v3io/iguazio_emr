#!/bin/bash

IGZ_EMR_VERSION=5.6.0

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
  # Run iguazio Data Platform services, including the v3io daemon
  sudo su - iguazio -c "/home/iguazio/igz/engine/node_runner/bin/log_server --logdir=/var/log/iguazio --log_files_size=5368709120 &"
  sudo su - iguazio -c "/home/iguazio/igz/clients/v3io/bin/v3io_daemon --config /home/iguazio/igz/daemon/config/daemon_config.json &"
  logger -T "running_iguazio_services done"
}

function main()
{
    local igz_data_node_ip=$1
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

    copy_artifacts
    create_user_iguazio
    install_daemon_config
    install_packages
    running_iguazio_services
    sysctl_update
    change_ulimit
    
    # Copy post-installation artifacts and change permissions
    sudo chmod 755 /opt/igz/spark/lib/*.sh
    . /opt/igz/spark/lib/post_install_${IGZ_EMR_VERSION}.sh &

    logger -T "Iguazio installation done"
}

# Execute the script
main $@
