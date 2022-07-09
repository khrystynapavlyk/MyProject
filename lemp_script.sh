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
