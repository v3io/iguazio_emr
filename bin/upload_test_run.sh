#!/bin/bash
source ~/.bashrc
export PATH="/home/iguazio/.local/bin:$PATH"
./bin/upload_emr_ver2S3.py --tag igz_0.12.6_b36_20170703185723
