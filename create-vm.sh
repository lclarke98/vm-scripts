#!/bin/bash

a=`curl -s -H "Metadata-Flavor: Google"  \
 "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip"`
echo "$a"
key=`curl -s -H "Metadata-Flavor: Google"  \
        "http://metadata.google.internal/computeMetadata/v1/instance/attributes/p"`
echo "$key"

for i in `seq 1 $1`
    do
	    gcloud compute instances create  \
          --machine-type f1-micro  \
          --metadata=p=$key,address=$a \
          --metadata-from-file  \
             startup-script=vm-script.sh  \
          --scopes=https://www.googleapis.com/auth/cloud-platform\
          vm$i
    done
    
    cd
    git clone https://github.com/portsoc/distributed-master-worker
    cd distributed-master-worker
    npm install
    sudo npm run server $key
    wait
    for i in `seq 1 $1`
    do
	    gcloud compute instances delete vm$i --delete-disks=all --zone=europe-west1-c
    done
    exit 0
