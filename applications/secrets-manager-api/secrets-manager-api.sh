#!/bin/bash
echo '=============== Staring init script for Secrets Manager API ==============='

# save all env for debugging
printenv > /var/log/colony-vars-"$(basename "$BASH_SOURCE" .sh)".txt

# Install dotnet core and dependencies
wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# Install the .Net Core framework, set the path, and show the version of core installed.
apt-get install -y apt-transport-https
apt-get update
apt-get install -y dotnet-sdk-3.1 && \
    export PATH=$PATH:$HOME/dotnet && \
    dotnet --version
apt-get update
apt-get install -y aspnetcore-runtime-3.1


# echo '==> Installing Apache'
# sudo apt update
# echo 'Updated'
# sudo apt install -y apache2
# echo 'Installed Apache'
# sudo ufw app list
# sudo ufw allow 'Apache'
# sudo ufw status
# sudo systemctl enable apache2
# sudo systemctl start apache2
# sudo systemctl status apache2

echo '===> Installing Nginx'
sudo apt update
sudo apt install -y nginx
sudo service nginx start


echo '==> Extract api artifact to /var/www/secrets-manager-api'
mkdir $ARTIFACTS_PATH/drop
tar -xvf $ARTIFACTS_PATH/secrets-manager-api.tar.gz -C $ARTIFACTS_PATH/drop/
mkdir /var/www/secrets-manager-api/
tar -xvf $ARTIFACTS_PATH/drop/drop/secrets-manager-api.tar.gz -C /var/www/secrets-manager-api

echo 'RELEASE_NUMBER='$RELEASE_NUMBER >> /etc/environment
echo 'API_BUILD_NUMBER='$API_BUILD_NUMBER >> /etc/environment
echo 'API_PORT='$API_PORT >> /etc/environment
# source /etc/environment

echo '==> Start our api'
cd /var/www/secrets-manager-api
# ./AWS.SecretMgr
