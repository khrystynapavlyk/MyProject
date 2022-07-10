#!/bin/bash
echo "Start creating new DATABASE"
echo $(mysql -e "SHOW DATABASES;")
sudo mysql -e "CREATE DATABASE "$1" DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
echo $(mysql -e "SHOW DATABASES;")
echo "End creating new DATABASE"

echo "Start to create user"
echo $(mysql -e "SELECT user FROM mysql.user;")
mysql -e "CREATE USER '"$2"'@'%' IDENTIFIED WITH mysql_native_password BY '"$3"';"
echo $(mysql -e "SELECT user FROM mysql.user;")
echo "End to create user"

echo "Start to grant all database to user"
echo $(mysql -e "SHOW GRANTS FOR "$2";")
mysql -e "GRANT ALL ON "$1".* TO '"$2"'@'%';"
echo $(mysql -e "SHOW GRANTS FOR "$2";")
echo "End to grant all database to user"

echo "Start FLUSH PRIVILEGES"
mysql -e "FLUSH PRIVILEGES;"
echo "Start FLUSH PRIVILEGES"

echo "Start apt update"
sudo apt update -y
echo "End apt update"

echo "Start checking apache or nginx"
findapache=$(dpkg --get-selections | grep apache)
findnginx=$(dpkg --get-selections | grep nginx)
if [ -n "$findapache" ]; then
echo "Apache exist"

echo "Start install php extensions"
sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y
echo "End install php extensions"

echo "Start systemctl restart apache2"
sudo systemctl restart apache2
echo "End systemctl restart apache2"

echo "Start creating khr_wordpress.cong"
cat << 'EOF' > /etc/apache2/sites-available/khr_wordpress.conf
<VirtualHost *:80>
    ServerName example.com
    DocumentRoot /var/www/khr_wordpress
    <Directory /var/www/khr_wordpress>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>
</VirtualHost>
EOF
echo "End creating khr_wordpress.cong"

echo "Start enable khr_wordpress.conf"
sudo a2ensite khr_wordpress.conf
sudo a2dissite khr_domain.conf
sudo systemctl reload apache2
echo "Endenable khr_wordpress.conf"

echo "Start a2enmod rewrite"
a2enmod rewrite
echo "End a2enmod rewrite"

echo "Start apache2ctl configtest"
OUTPUT=$(sudo apache2ctl configtest)
echo "${OUTPUT}"
echo "End apache2ctl configtest"

echo "Start systemctl restart apache2"
systemctl restart apache2
echo "End systemctl restart apache2"

echo "Srart a2enmod rewrite"
sudo a2enmod rewrite
echo "End a2enmod rewrite"

echo "Start apache2ctl configtest"
sudo apache2ctl configtest
echo "End apache2ctl configtest"

echo "Start systemctl restart apache2"
sudo systemctl restart apache2
echo "End systemctl restart apache2"

echo "Srart cd /tmp && curl -O https://wordpress.org/latest.tar.gz"
cd /tmp && curl -O https://wordpress.org/latest.tar.gz
echo "End cd /tmp && curl -O https://wordpress.org/latest.tar.gz"

echo "Start tar xzvf /tmp/latest.tar.gz"
tar xzvf /tmp/latest.tar.gz
echo "End tar xzvf /tmp/latest.tar.gz"

echo "Start touch /tmp/wordpress/.htaccess"
touch /tmp/wordpress/.htaccess
echo "End touch /tmp/wordpress/.htaccess"

echo "Start cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php"
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
echo "End cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php"

echo "Start mkdir /tmp/wordpress/wp-content/upgrade"
mkdir /tmp/wordpress/wp-content/upgrade
echo "End mkdir /tmp/wordpress/wp-content/upgrade"

echo "Start cp -a /tmp/wordpress/. /var/www/khr_wordpress"
sudo cp -a /tmp/wordpress/. /var/www/khr_wordpress
echo "End cp -a /tmp/wordpress/. /var/www/khr_wordpress"

echo "Start chown -R www-data:www-data /var/www/khr_wordpress"
sudo chown -R www-data:www-data /var/www/khr_wordpress
echo "End chown -R www-data:www-data /var/www/khr_wordpress"

echo "Start find /var/www/khr_wordpress/ -type d -exec chmod 750 {} \;"
sudo find /var/www/khr_wordpress/ -type d -exec chmod 750 {} \;
echo "End find /var/www/khr_wordpress/ -type d -exec chmod 750 {} \;"

echo "Start find /var/www/khr_wordpress/ -type f -exec chmod 640 {} \;"
sudo find /var/www/khr_wordpress/ -type f -exec chmod 640 {} \;
echo "End find /var/www/khr_wordpress/ -type f -exec chmod 640 {} \;"

elif [ -n "$findnginx" ]; then
echo "Nginx exist"

echo "Start install php extensions"
sudo apt install php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip -y
echo "End install php extensions"

echo "Start systemctl restart php7.4-fpm"
sudo systemctl restart php7.4-fpm
echo "End systemctl restart php7.4-fpm"

echo "Start Configuring Nginx"
cat << 'EOF' > /etc/nginx/sites-available/khr_wordpress
server {
        listen 80;

        root /var/www/khr_wordpress;
        index index.php index.html index.htm;

         server_name khr_domain www.khr_domain;

location / {
                # try_files $uri $uri/ =404;
                try_files $uri $uri/ /index.php?q=$uri&$args;
        }

# Pass PHP requests to PHP_FPM

        location ~ \.php$ {
                try_files $uri =404;
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
                fastcgi_index index.php;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include fastcgi_params;
        }

location = /favicon.ico {
        access_log off;
        log_not_found off;
        expires max;
}

location = /robots.txt {
        access_log off;
        log_not_found off;
}


error_page 404 /404.html;

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
                root /usr/share/nginx/html;
        }

# Deny Access to Hidden Files such as .htaccess

location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
}

# Disallow PHP files In the WordPress uploads directory

location /wp-content/uploads/ {
        location ~ \.php$ {
                deny all;
        }
}
}
EOF
echo "End Configuring Nginx"

echo "Start nginx -t"
sudo nginx -t
echo "End nginx -t"

echo "Start systemctl reload nginx"
sudo systemctl reload nginx
echo "End systemctl reload nginx"

echo "Srart cd /tmp && curl -O https://wordpress.org/latest.tar.gz"
cd /tmp && curl -LO https://wordpress.org/latest.tar.gz
echo "End cd /tmp && curl -O https://wordpress.org/latest.tar.gz"

echo "Start tar xzvf /tmp/latest.tar.gz"
tar xzvf /tmp/latest.tar.gz
echo "End tar xzvf /tmp/latest.tar.gz"

echo "Start cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php"
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
echo "End cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php"

echo "Start cp -a /tmp/wordpress/. /var/www/khr_wordpress"
sudo cp -a /tmp/wordpress/. /var/www/khr_wordpress
echo "End cp -a /tmp/wordpress/. /var/www/khr_wordpress"

echo "Start chown -R www-data:www-data /var/www/khr_wordpress"
sudo chown -R www-data:www-data /var/www/khr_wordpress
echo "End chown -R www-data:www-data /var/www/khr_wordpress"

else
echo "Apache and nginx not exists"
fi
echo "End checking apache or nginx"

echo "Start setting Up the WordPress Configuration File"
SALT=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
STRING='put your unique phrase here'
printf '%s\n' "g/$STRING/d" a "$SALT" . w | ed -s /var/www/khr_wordpress/wp-config.php
echo "End setting Up the WordPress Configuration File"

echo "Start to modify database_name_here"
sed -i "s/database_name_here/$1/g" /var/www/khr_wordpress/wp-config.php
echo "End to modify database_name_here"

echo "Start to modify username_here"
sed -i "s/username_here/$2/g" /var/www/khr_wordpress/wp-config.php
echo "End to modify username_here"

echo "Start to modify password_here"
sed -i "s/password_here/$3/g" /var/www/khr_wordpress/wp-config.php
echo "End to modify password_here"

echo "Start to add define('FS_METHOD', 'direct');"
echo "define('FS_METHOD', 'direct');" >> /var/www/khr_wordpress/wp-config.php
echo "End to add define('FS_METHOD', 'direct');"
