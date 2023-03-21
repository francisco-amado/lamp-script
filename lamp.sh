#!/bin/bash

#LAMP stack installation (Ubuntu 20.04 LTS, Apache 2, MariaDB 10, PHP 7.4)

echo -e "Updating and upgrading the system\n"
sudo apt update -y && sudo apt upgrade -y

echo -e "\nInstalling the Apache server and enabling rewrite and ssl modules\n"
sudo apt install -y apache2

if [ -n "$( (echo | a2enmod | grep rewrite) )" ]; then
sudo a2enmod rewrite
fi

if [ -n "$( (echo | a2enmod | grep ssl) )" ]; then
sudo a2enmod ssl
fi

sudo systemctl restart apache2

echo -e "\nConfiguring the firewall\n"

if [ -n "$( (apt-cache policy ufw | grep none) )" ]; then
sudo apt install -y ufw
fi

if [ -z "$( (ps -ef | pgrep ufw) )" ]; then
sudo systemctl start ufw
fi

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow in "Apache Full"
printf "y\n" | sudo ufw enable
sudo systemctl restart apache2

#If you are working on a cloud system with a firewall comment everything related to ufw and uncomment this:
#if [ -n "$( (apt-cache policy iptables-persistent | grep none) )" ]; then
#sudo apt install -y iptables-persistent
#fi
#sudo iptables -I INPUT 1 -m state --state NEW -p tcp --dport 80 -j ACCEPT
#sudo iptables -I INPUT 2 -m state --state NEW -p tcp --dport 443 -j ACCEPT
#sudo netfilter-persistent save

echo -e "\nInstalling PHP\n"

sudo apt install -y php
sudo apt install -y php-mysqli php-curl php-gd php-zip php-dom php-imagick php-intl php-xml 
sudo systemctl restart apache2

echo -e "\Configuring the Apache directory\n"

sudo adduser "$( (whoami) )" www-data
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R g+rw /var/www/html

echo -e "\Installing MariaDB\n"

sudo apt install -y mariadb-server
sudo systemctl start mariadb.service
#Change the password provided here to a more secure one, if you want
sudo mariadb -e "SET PASSWORD FOR root@localhost = PASSWORD('root');FLUSH PRIVILEGES;" 
#Swap "root" for the password you chose
printf "root\n n\n y\n y\n y\n y\n" | sudo mysql_secure_installation
sudo systemctl restart apache2

echo -e "\nLAMP configuration done! Enjoy your development :)"