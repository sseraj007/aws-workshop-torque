#!/bin/bash
echo '=============== Staring init script for Secrets Manager API ==============='

# save all env for debugging
printenv > /var/log/colony-vars-"$(basename "$BASH_SOURCE" .sh)".txt

echo '==> Installing Apache'
sudo apt update
echo 'Updated'
sudo apt install -y apache2
echo 'Installed Apache'
sudo ufw app list
sudo ufw allow 'Apache'
sudo ufw status
sudo systemctl enable apache2
sudo systemctl start apache2
sudo systemctl status apache2

echo '==> Extract api artifact to /var/secrets-manager-api'
mkdir $ARTIFACTS_PATH/drop
tar -xvf $ARTIFACTS_PATH/secrets-manager-api.tar.gz -C $ARTIFACTS_PATH/drop/
mkdir /var/secrets-manager-api/
tar -xvf $ARTIFACTS_PATH/drop/drop/secrets-manager-api.tar.gz -C /var/secrets-manager-api

echo 'RELEASE_NUMBER='$RELEASE_NUMBER >> /etc/environment
echo 'API_BUILD_NUMBER='$API_BUILD_NUMBER >> /etc/environment
echo 'API_PORT='$API_PORT >> /etc/environment
# source /etc/environment

echo '==> Start our api and configure as a daemon using pm2'
cd /var/secrets-manager-api
start AWS.SecretMgr
