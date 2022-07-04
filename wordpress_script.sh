#!/bin/bash
echo "Start apt update"
sudo apt update -y
echo "End apt update"

echo "Start apt install"
sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y
echo "End apt install"

echo "Start systemctl restart apache2"
sudo systemctl restart apache2
echo "End systemctl restart apache2"

echo "Start creating khr_wordpress.cong"
cat << 'EOF' > /etc/apache2/sites-available/khr_wordpress.conf
<Directory /var/www/khr_wordpress/>
        AllowOverride All
</Directory>
EOF
echo "End creating khr_wordpress.cong"

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

echo "Start setting Up the WordPress Configuration File"
SALT=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
STRING='put your unique phrase here'
printf '%s\n' "g/$STRING/d" a "$SALT" . w | ed -s /var/www/khr_wordpress/wp-config.php
echo "End setting Up the WordPress Configuration File"

