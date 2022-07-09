#!/bin/bash
echo "Start apt update"
sudo apt update -y
echo "End apt update"

echo "Start apt install nginx"
sudo apt install nginx -y
echo "End apt install nginx"

echo "Start sudo ufw app list"
OUTPUT=$(sudo ufw app list)
echo "${OUTPUT}"
echo "End sudo ufw app list"

echo "Start ufw allow 'Nginx HTTP'"
sudo ufw allow 'Nginx HTTP'
echo "End ufw allow 'Nginx HTTP'"

echo "start sudo ufw status"
OUTPUT=$(sudo ufw status)
echo "${OUTPUT}"
echo "end sudo ufw status"

echo "start installing mysql-server"
sudo apt install mysql-server -y
echo "end installing mysql-server"

echo "start mysql_secure_installation"
sudo mysql -e "SET PASSWORD FOR root@localhost = PASSWORD('123');FLUSH PRIVILEGES;"
echo "end mysql_secure_installation"

echo "start FLUSH PRIVILEGES"
mysql -e "FLUSH PRIVILEGES"
echo "end FLUSH PRIVILEGES"

echo "start instaling php"
sudo apt install php libapache2-mod-php php-mysql -y
echo $(php -v)
echo "end instaling php"
