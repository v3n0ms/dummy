#!/bin/bash

sudo apt update
sudo apt install --yes apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

sudo echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list 
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/cloud.google.gpg
sudo apt-get update && sudo apt-get install google-cloud-cli  -y

sudo systemctl start docker
METADATA=http://metadata.google.internal/computeMetadata/v1
SVC_ACCT=$METADATA/instance/service-accounts/default
ACCESS_TOKEN=$(curl -H 'Metadata-Flavor: Google' $SVC_ACCT/token \
    | cut -d'"' -f 4)
sudo docker login  -u _token -p $ACCESS_TOKEN https://asia.gcr.io

sudo docker run -p 8080:8080 -d -e DB_USER=root -e DB_NAME=pos -e DB_PASSWORD=Sup3r$ecretP@ss -e DB_HOST=35.85.207.237 asia.gcr.io/dummy-project-365407/pos