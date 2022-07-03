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

