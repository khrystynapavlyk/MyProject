#!/bin/bash
echo "start apt update"
sudo apt update -y
echo "end apt update"

echo "start apt install apache2"
sudo apt install apache2 -y
echo "end apt install apache2"

echo "start sudo ufw app list"
OUTPUT=$(sudo ufw app list)
echo "${OUTPUT}"
echo "end sudo ufw app list"

echo "start ufw allow in "Apache""
sudo ufw allow in "Apache"
echo "end ufw allow in "Apache""

echo "start sudo ufw status"
OUTPUT=$(sudo ufw status)
echo "${OUTPUT}"
echo "end sudo ufw status"

echo "start change status"
status=$(sudo ufw status | grep -i status | sed 's/Status: //')
if [ "$status" == "inactive" ]; then
sudo ufw enable
echo "changed status to active"
else
echo "Status ufw is active"
fi
echo "end change status"

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


