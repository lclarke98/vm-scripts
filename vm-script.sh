#!/bin/bash
trap "exit" INT TERM ERR
trap "kill 0" EXIT

sudo curl -sL https://deb.nodesource.com/setup_12.x | bash - 
sudo apt-get install -y git nodejs
    key=`curl -s -H "Metadata-Flavor: Google"  \
        "http://metadata.google.internal/computeMetadata/v1/instance/attributes/p"`
    address=`curl -s -H "Metadata-Flavor: Google"  \
        "http://metadata.google.internal/computeMetadata/v1/instance/attributes/address"`
    git clone https://github.com/portsoc/distributed-master-worker
    cd distributed-master-worker
    npm install
    sleep 5m
    npm run client $key $address &&
wait
sudo poweroff
