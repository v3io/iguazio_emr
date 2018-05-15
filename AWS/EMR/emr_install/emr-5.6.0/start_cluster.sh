./install_emr-5.6.0.sh ./config/install_emr-5.6.0.cfg
ClusterId=`cat /tmp/ClusterId`
EMRMASTER="/tmp/EMRMASTER"
aws emr describe-cluster --cluster-id $ClusterId | python -c "import sys, json; print json.load(sys.stdin)['Cluster']['MasterPublicDnsName']"  > $EMRMASTER

