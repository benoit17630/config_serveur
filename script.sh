#!/bin/bash

echo 'install composer'
apt update
apt install -y php apache2 libapache2-mod-php php-mysql php-xml  
apt install -y mariadb-server mariadb-client  
apt install -y composer
apt install vim git snapd

service apache2 start
service mysql start
echo "instal snap"
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot

CERTBOT=$(ls /usr/bin | grep certbot)
if [ -z "$CERTBOT" ];
then 
       echo "On cree le lien /usr/bin/cerbot"
       ln -s /snap/bin/cerbot /usr/bin/cerbot
fi

MD5_DEST=$(md5sum /etc/apache2/sites-available/000-default.conf | awk '{print $1}')
MD5_SRC=$(md5sum 000-default.conf | awk '{print $1}')

if [ "$MD5_DEST" != "$MD5_SRC" ]
then
            echo "ont ecrase la conf apache"
            cp 000-default.conf /etc/apache2/sites-available/000-default.conf
            service apache2 restart

fi


echo "pull sources git"
# je choisit mon pâth
cd /var/www/html

GIT_CMD=$(ls -lsa /var/www/html | grep .git)
if [ -z ["GIT_CMD"] ];
 then
     git init
     git remote add origin https://github.com/benoit17630/monBlog.git
fi

#je pull  mon dossier 
git pull origin main
 composer install 
chown -R www-data:www-data /var/www/html/ 
source .env

ENV_DEST=$(md5sum /var/www/html/.env | awk '{print $1}')
ENV_SRC=$(md5sum /opt/config_serveur/.env | awk '{print $1}')

if [ "ENV_DEST" != "ENV_SRC" ];
 then
     echo 'ont ecrase le .env'
     cp .env /var/www/html/.env

fi

echo " penser a taper la commande certbot --apache"

