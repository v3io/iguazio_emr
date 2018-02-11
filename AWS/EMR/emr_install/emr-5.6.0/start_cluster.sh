./install_emr-5.6.0.sh ./config/install_emr-5.6.0.cfg
ClusterId=`cat /tmp/ClusterId`
EMRMASTER="/tmp/EMRMASTER"
aws emr ssh --cluster-id $ClusterId --key-pair-file $HOME/.aws/emr-virginia-key.pem --command "date"  2>&1 | grep -o "ec2\S*" | tail -1 > $EMRMASTER
