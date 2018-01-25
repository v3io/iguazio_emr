#!/bin/bash
cd ./AWS/EMR/emr_install/emr-5.6.0/
export PATH="$HOME/cli-ve/bin/:$PATH"
if [ -f ./install_emr-5.6.0.sh ]; then 

./install_emr-5.6.0.sh ./config/install_emr-5.6.0.cfg

else
	echo "you are in the wrong directory "
	echo "$PWD"
fi
