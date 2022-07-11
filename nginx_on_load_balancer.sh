#!/bin/bash

echo "Start apt-get install nginx"
sudo apt-get install nginx -y
echo "End apt-get install nginx"

echo "Start systemctl start nginx"
sudo systemctl start nginx
echo "End systemctl start nginx"

echo "Start systemctl enable nginx"
sudo systemctl enable nginx
echo "End systemctl enable nginx"

echo "Start systemctl status nginx"
OUTPUT=$(sudo systemctl status nginx)
echo "${OUTPUT}"
echo "End systemctl status nginx"

echo "Start ss -antpl"
OUTPUT=$(sudo ss -antpl)
echo "${OUTPUT}"
echo "End ss -antpl"

echo "Start ufw status"
sudo ufw status
echo "End ufw status"

echo "Start ufw allow 'Nginx HTTP'"
sudo ufw allow 'Nginx HTTP'
echo "End ufw allow 'Nginx HTTP'"

echo "Start ufw status"
sudo ufw status
echo "End ufw status"
