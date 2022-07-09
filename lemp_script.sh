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

echo "Start sudo ufw status"
OUTPUT=$(sudo ufw status)
echo "${OUTPUT}"
echo "End sudo ufw status"

echo "Start installing mysql-server"
sudo apt install mysql-server -y
echo "End installing mysql-server"

echo "Start mysql_secure_installation"
sudo mysql -e "SET PASSWORD FOR root@localhost = PASSWORD('123');FLUSH PRIVILEGES;"
echo "End mysql_secure_installation"

echo "Start FLUSH PRIVILEGES"
mysql -e "FLUSH PRIVILEGES"
echo "End FLUSH PRIVILEGES"

echo "Start instaling php"
sudo apt install php-fpm php-mysql -y
echo $(php -v)
echo "End instaling php"

echo "Start mkdir my_domin"
sudo mkdir /var/www/khr_domain
echo "End mkdir my_domin"

echo "Start assign ownership of the directoryecho "
sudo chown -R $USER:$USER /var/www/khr_domain
echo "End assign ownership of the directory"

echo "Start to open a new configuration file in Nginx’s"
cat << 'EOF' > /etc/nginx/sites-available/khr_domain
server {
    listen 80;
    server_name khr_domain www.khr_domain;
    root /var/www/khr_domain;

    index index.html index.htm index.php;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
     }

    location ~ /\.ht {
        deny all;
    }

}
EOF
echo "End to open a new configuration file in Nginx’s"
