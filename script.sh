#!/bin/bash

toolbox 
sudo apt-get install apt-transport-https ca-certificates gnupg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update && sudo apt-get install google-cloud-cli

gcloud auth activate-service-account --key-file=credentials.json

docker pull asia.gcr.io/dummy-project-365407/pos tag pos
docker run -p 8080:8080 -d -e DB_USER=root -e DB_NAME=pos -e DB_PASSWORD=Sup3r$ecretP@ss -e DB_HOST=34.150.222.6 pos 