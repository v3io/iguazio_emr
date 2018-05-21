#!/bin/bash

IGZ_EMR_VERSION="5.12.1" 

function help {
    echo "install_emr-${IGZ_EMR_VERSION}.sh: Installs an EMR cluster."
    echo "USAGE: ./install_emr-${IGZ_EMR_VERSION}.sh <custom configuration file>"
    echo ""
    echo "PARAMETERS"
    echo "<custom configuration file> - Required."
    echo "    Path to a custom EMR-cluster configuration file."
    echo ""
    echo "EXAMPLE"
    echo "./install-emr-${IGZ_EMR_VERSION}.sh config/install_emr-${IGZ_EMR_VERSION}.cfg"
}

function print_public_dns_names()
{
  echo "The spark availible by following url:"
  echo
  TMP_id=0
  for k in `aws emr list-instances --cluster-id $ClusterId | grep PublicDnsName | awk '{ print $2 }' | sed 's/[\",]//g'`; do
    if [ $TMP_id -eq 0 ]; then
            echo "[master] -> $k"
            echo "[zeppelin] -> http://$k:8090"
            echo "[historyServer] -> http://$k:18080"
            echo "[yarn ResourceManager] -> http://$k:8088"
            echo "[spark job] -> http://$k:20888"
            ((TMP_id++))
    else
            echo "[core] slave $k"
            ((TMP_id++))
    fi
  done
}

function info_bunner()
{
  instance_id=0
  ANSIBLE_HOSTS="/tmp/hosts"
  HOST_LIST="/tmp/hostlist"
  VERSION="/tmp/version"
  echo
	echo "connection with csshX for macOS workstation:"
	echo
	echo "csshX --ssh_args \" -i  ~/${SSH_KEY_PAIR_NAME}.pem\" --login iguazio --hosts $HOST_LIST "
	echo
	echo "connection string with tmux for linux workstation:"
	echo
	echo "tmux-cssh -u iguazio --identity ~/${SSH_KEY_PAIR_NAME}.pem \\"
	echo 
	echo "connection to the master node "
	echo "aws emr ssh --cluster-id $ClusterId --key-pair-file ~/${SSH_KEY_PAIR_NAME}.pem"
	echo

  for i in `aws emr list-instances --cluster-id $ClusterId | grep PublicIpAddress | awk ' { print $2 } ' | sed 's/[\",]//g'`; do
		echo -sc "$i  \\ "
		if [ $instance_id -eq 0 ]; then
						echo "[master]" > $ANSIBLE_HOSTS
						echo "$i ansible_ssh_private_key_file=${HOME}/${SSH_KEY_PAIR_NAME}.pem" >> $ANSIBLE_HOSTS
						echo $i 	     >  $HOST_LIST
						echo "[cores]" >> $ANSIBLE_HOSTS
						((instance_id++))
		else
						echo "$i ansible_ssh_private_key_file=${HOME}/${SSH_KEY_PAIR_NAME}.pem" >> $ANSIBLE_HOSTS
						echo $i         >> $HOST_LIST
            ((instance_id++))
		fi
	done

  echo
	echo "EMR cluster $CLUSTER_NAME created done"
	echo "EMR ansible hosts file created done   "
	echo
	echo " ------------------------------------ "
	cat $ANSIBLE_HOSTS
	echo " ------------------------------------ "
	echo
}

function show_progress()
{
  #check cluster status exit when status changing to "Cluster ready"
  #in other case wait 5 sec and try 
  #exit from procedure after 10 min in any case  

  for i in `seq 1 100`; do
      echo -ne "[INFO]: running            = (${i}%) done\r"
      sleep 5 
      aws emr describe-cluster --cluster-id `cat /tmp/ClusterId`  > /tmp/status
      grep "Cluster ready" /tmp/status
      if [ $? -eq 0 ]; then 
        echo -ne "[INFO]: running            = 100% done\r"
        sleep 1
        break
      fi 
  done
  echo -ne '\n'
}

function save_cluster_id()
{
  echo $ClusterId > /tmp/ClusterId
}

function main() {
    # Load the custom EMR-cluster configuration file
    local custom_cfg_file
    if [ $# -gt 0 ]; then
        if [ -e ${1} ]; then
            custom_cfg_file=$1
            echo "[INFO]: Loading custom configuration file $custom_cfg_file ..."
            source $custom_cfg_file

            # #generate unique cluster-name
            # tmpStr=$(printf "\\$(printf %o `date +%s`)")
            # export CLUSTER_NAME="${CLUSTER_NAME}_${tmpStr}"
        else
            echo -e "[ERROR]: Could not find configuration file $custom_cfg_file.\n"
            help
            exit
        fi
    else
        help
        exit
    fi
    # Print the loaded custom EMR-cluster configuration
    echo "[INFO]: CLUSTER_NAME       = ${CLUSTER_NAME:? NOT DEFINED}"
    echo "[INFO]: S3_BUCKET_NAME     = ${S3_BUCKET_NAME:? NOT DEFINED}"
    echo "[INFO]: IGZ_DATA_NODE_IP   = ${IGZ_DATA_NODE_IP:? NOT DEFINED}"
    echo "[INFO]: SSH_KEY_PAIR_NAME  = ${SSH_KEY_PAIR_NAME:? NOT DEFINED}"
    echo "[INFO]: SUBNET_ID          = ${SUBNET_ID:? NOT DEFINED}"
    echo "[INFO]: EC2_INSTANCE_COUNT = ${EC2_INSTANCE_COUNT:? NOT DEFINED}"
    echo "[INFO]: EC2_INSTANCE_TYPE  = ${EC2_INSTANCE_TYPE:? NOT DEFINED}"
    echo "[INFO]: CONFIG_FILE        = ${CONFIG_FILE:? NOT DEFINED}"
    echo "[INFO]: DEBUG              = ${DEBUG:? NOT DEFINED}"

    # Set path to the S3-bucket installation directory
    S3_BUCKET_DIR="s3://${S3_BUCKET_NAME}/emr-${IGZ_EMR_VERSION}/artifacts"

    # Create the AWS EMR cluster
    if [ $DEBUG -eq 0 ]; then
      echo "[INFO]: Creating AWS EMR cluster $CLUSTER_NAME ..."
      ClusterId=`aws emr create-cluster \
        --name "$CLUSTER_NAME" \
        --release-label emr-${IGZ_EMR_VERSION} --use-default-roles \
        --ec2-attributes KeyName=$SSH_KEY_PAIR_NAME,SubnetId=$SUBNET_ID \
        --applications Name=Hadoop Name=Spark Name=Zeppelin Name=Ganglia Name=Presto Name=Oozie \
        --instance-count $EC2_INSTANCE_COUNT \
        --instance-type $EC2_INSTANCE_TYPE \
        --bootstrap-action \
        Path="$S3_BUCKET_DIR/download-${IGZ_EMR_VERSION}.sh",Args=[$IGZ_DATA_NODE_IP,$S3_BUCKET_DIR]  \
        --configurations file://$PWD/$CONFIG_FILE \
        --tags application=$CLUSTER_NAME | awk '/ClusterId/ { print $2 }' | sed 's/[\",]//g'`
    else
      echo "[INFO]: Creating AWS EMR cluster $CLUSTER_NAME ..."
      ClusterId=`aws emr create-cluster \
          --name "$CLUSTER_NAME" \
          --release-label emr-${IGZ_EMR_VERSION} --use-default-roles \
          --ec2-attributes KeyName=$SSH_KEY_PAIR_NAME,SubnetId=$SUBNET_ID \
          --applications Name=Hadoop Name=Spark Name=Zeppelin Name=Ganglia Name=Presto Name=Oozie \
          --instance-count $EC2_INSTANCE_COUNT \
          --instance-type $EC2_INSTANCE_TYPE \
          --bootstrap-action \
          Path="$S3_BUCKET_DIR/download-${IGZ_EMR_VERSION}.sh",Args=[$IGZ_DATA_NODE_IP,$S3_BUCKET_DIR] --log-uri s3://${S3_BUCKET_LOG_NAME}/log \
          --configurations file://$PWD/$CONFIG_FILE \
          --tags application=$CLUSTER_NAME  | awk '/ClusterId/ { print $2 }' | sed 's/[\",]//g' `
    fi

    show_progress
    info_bunner
    print_public_dns_names
    save_cluster_id
}

# Execute the script
main $@
