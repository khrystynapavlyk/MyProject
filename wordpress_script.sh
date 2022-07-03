#!/bin/bash
echo "start apt update"
sudo apt update -y
echo "end apt update"

echo "start apt install "
sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y
echo "end apt install"

echo "start systemctl restart apache2"
sudo systemctl restart apache2
echo "end systemctl restart apache2 "
