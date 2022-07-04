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
