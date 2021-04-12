#!/bin/bash

echo 'install composer'
apt update
apt install -y php apache2 libapache2-mod-php php-mysql php-xml  
apt install -y mariadb-server mariadb-client  
apt install -y composer
pat install vtm git

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

