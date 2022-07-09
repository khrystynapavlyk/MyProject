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

echo "Start to add php7.4"
sudo apt install software-properties-common -y
sudo add-apt-repository --yes ppa:ondrej/php
sudo apt-get install php7.4-fpm php7.4-mysql -y
sudo service nginx restart
sudo service php7.4-fpm restart
echo "End to add php7.4"

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

echo "Start ln -s /etc/nginx/sites-available/khr_domain /etc/nginx/sites-enabled/"
sudo ln -s /etc/nginx/sites-available/khr_domain /etc/nginx/sites-enabled/
echo "End ln -s /etc/nginx/sites-available/khr_domain /etc/nginx/sites-enabled/"

echo "Start unlink /etc/nginx/sites-enabled/default"
sudo unlink /etc/nginx/sites-enabled/default
echo "End unlink /etc/nginx/sites-enabled/default"

echo "Start nginx -t"
OUTPUT=$(nginx -t)
echo "${OUTPUT}"
echo "End nginx -t"

echo "Start systemctl reload nginx"
sudo systemctl reload nginx
echo "End systemctl reload nginx"

echo "Start to add index.html"
cat << 'EOF' > /var/www/khr_domain/index.html
<html>
  <head>
    <title>khr_domain website</title>
  </head>
  <body>
    <h1>Hello World!</h1>

    <p>This is the landing page of <strong>khr_domain</strong>.</p>
  </body>
</html>
EOF
echo "End to add index.html"

echo "Start creating new database"
echo $(mysql -e "SHOW DATABASES;")
mysql -e "CREATE DATABASE "$1"";
echo $(mysql -e "SHOW DATABASES;")
echo "End creating new database"

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

echo "Start creating tables in "$1""
echo $(mysql -e "SHOW TABLES IN "$1";")
mysql -e "CREATE TABLE "$1".todo_list (item_id INT AUTO_INCREMENT, content VARCHAR(255), PRIMARY KEY(item_id));"
echo $(mysql -e "SHOW TABLES IN "$1";")
echo "End creating tables in khr_database"

echo "Start to insert text into todo_list table"
echo $(mysql -e "SELECT * FROM "$1".todo_list;")
mysql -e "INSERT INTO "$1".todo_list (content) VALUES ('Hi');"
mysql -e "INSERT INTO "$1".todo_list (content) VALUES ('How are you?');"
mysql -e "INSERT INTO "$1".todo_list (content) VALUES ('Goodbye');"
echo $(mysql -e "SELECT * FROM "$1".todo_list;")
echo "End to insert text into todo_list table"

echo "Start adding todo_list.php"
cat << 'EOF' > /var/www/khr_domain/todo_list.php
<?php
$user = "db_user";
$password = "db_password";
$database = "db_database";
$table = "todo_list";
try {
  $db = new PDO("mysql:host=localhost;dbname=$database", $user, $password);
  echo "<h2>TODO</h2><ol>";
  foreach($db->query("SELECT content FROM $table") as $row) {
    echo "<li>" . $row['content'] . "</li>";
  }
  echo "</ol>";
} catch (PDOException $e) {
    print "Error!: " . $e->getMessage() . "<br/>";
    die();
}
EOF
echo "End adding todo_list.php"

echo "Start to modify database_name_here"
sed -i "s/db_database/$1/g" /var/www/khr_domain/todo_list.php
echo "End to modify database_name_here"

echo "Start to modify username_here"
sed -i "s/db_user/$2/g" /var/www/khr_domain/todo_list.php
echo "End to modify username_here"

echo "Start to modify password_here"
sed -i "s/db_password/$3/g" /var/www/khr_domain/todo_list.php
echo "End to modify password_here"
