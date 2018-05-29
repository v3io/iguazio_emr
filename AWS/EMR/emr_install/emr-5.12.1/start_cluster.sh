IGZ_EMR_VERSION="5.12.1"
./install_emr-$IGZ_EMR_VERSION.sh ./config/install_emr-$IGZ_EMR_VERSION.cfg
ClusterId=`cat /tmp/ClusterId`
EMRMASTER="/tmp/EMRMASTER"
aws emr describe-cluster --cluster-id $ClusterId | python -c "import sys, json; print json.load(sys.stdin)['Cluster']['MasterPublicDnsName']"  > $EMRMASTER

