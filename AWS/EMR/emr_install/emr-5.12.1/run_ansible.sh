#!/bin/bash

case $1 in
  get_status)
    echo "Checking if v3io_daemon process and log_server is running"
    ansible-playbook ./playbooks/get_status.yml --user iguazio -i /tmp/hosts -v
    ;;
  get_logs)
    echo "Aggrigating the statistics and logs from the host to the local station"
    ansible-playbook ./playbooks/get_logs.yml --user iguazio -i /tmp/hosts -v
    ;;
  clean_logs)
    echo "Cleaning extra logs and statistics from the remote node"
     ansible-playbook ./playbooks/clean_stats_logs.yml --user iguazio -i /tmp/hosts -v
    ;;
  restart_v3io)
    echo "Restarting v3io_daemon and log_server"
    ansible-playbook ./playbooks/restart_v3io.yml --user iguazio -i /tmp/hosts -v
    ;;
  run_debug_mode)
    echo "Changing  v3io_daemon log level to the debug level 7"
    ansible-playbook ./playbooks/run_debug_mode.yml --user iguazio -i /tmp/hosts -v
    ;;
  run_prod_mode)
    echo "Changing the log level to production silent level 3"
    ansible-playbook ./playbooks/run_production_mode.yml --user iguazio -i /tmp/hosts -v
    ;;
  upload_file)
    echo "Uploading file ${2:? FILE NAME IS NOT PASSED} "
    ansible-playbook ./playbooks/upload_file.yml --user iguazio -i /tmp/hosts --extra-vars "file_to_upload=$2"
    ;;
  *)
    Message="This argument is not implemented yet"
    echo "$0 HELP"
    echo "  $0 here supported options:"
    echo "  $0 get_status"
    echo "  $0 get_logs"
    echo "  $0 clean_logs"
    echo "  $0 restart_v3io"
    echo "  $0 run_debug_mode"
    echo "  $0 run_prod_mode"
    echo "  $0 upload_file {FILENAME} - copy file from /tmp/debug directory and spread it to the cluster"
    ;;
esac
