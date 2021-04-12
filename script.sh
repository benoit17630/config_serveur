#!/bin/bash

echo 'install composer'
apt update
apt install -y php apache2 libapache2-mod-php php-mysql php-xml  
apt install -y mariadb-server mariadb-client  
apt install -y composer
apt install vim git snapd

echo "instal snap"
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot

CERTBOT=$(ls /usr/bin | grep certbot)
if [-Z "$CERTBOT"]
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
#je pull  mon dossier 
git pull origin main
 composer install 
chown -R www-data:www-data /var/www/html/ 
source .env

echo " penser a taper la commande certbit --apache"

