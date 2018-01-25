#!/bin/bash

#verify if hosts file configured with two groups
#get ping ok if servers are availible

ansible kubernetes-master -m ping
ansible kubernetes-workers -m ping

#run master kubernetes instrallation
ansible-playbook ./playbooks/slave_kubernetes.yml --user iguazio -i ./playbooks/spark/tests/inventory -v
ansible-playbook ./playbooks/master_kubernetes.yml --user iguazio -i ./playbooks/spark/tests/inventory -v
