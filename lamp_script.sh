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
sudo ufw --force enable
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

echo "start mkdir my_domin"
sudo mkdir /var/www/khr_domain
echo "end mkdir my_domin"

echo "start assign ownership of the directoryecho "
sudo chown -R $USER:$USER /var/www/khr_domain
echo "start assign ownership of the directory"

echo "start configuring virtual host1"
cat << 'EOF' > /etc/apache2/sites-available/khr_domain.conf
<VirtualHost *:80>
    ServerName khr_domain
    ServerAlias www.khr_domain
    ServerAdmin khr@localhost
    DocumentRoot /var/www/khr_domain
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
echo "end configuring virtual host1"

echo "start configuring virtual host2"
sudo a2ensite khr_domain
sudo a2dissite 000-default
echo $(apache2ctl configtest)
sudo systemctl reload apache2
echo "end configuring virtual host2"

echo "add index.html"
cat << EOF > /var/www/khr_domain/index.html
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
echo "end add index.html"

echo "Start adding directoryIndex settings on Apache"
cat << EOF > /etc/apache2/mods-enabled/dir.conf
<IfModule mod_dir.c>
         DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>
EOF
echo "End adding directoryIndex settings on Apache"

echo "Start systemctl reload apache2"
sudo systemctl reload apache2
echo "End systemctl reload apache2" 

echo "Start testing PHP Processing on my Web Server"
cat << EOF > /var/www/khr_domain/info.php
<?php
phpinfo();
EOF
echo "End testing PHP Processing on my Web Server"

echo "Start creating new database"

echo $(mysql -e "SHOW DATABASES;")
mysql -e "CREATE DATABASE khr_database;"
echo $(mysql -e "SHOW DATABASES;")

echo "End creating new database" 

echo"Start to create user"

echo $(mysql -e "SELECT user FROM mysql.user;")
mysql -e "CREATE USER 'khr_user'@'%' IDENTIFIED BY '123';"
echo $(mysql -e "SELECT user FROM mysql.user;")

echo "End to create user"

echo "Star to giving my user permission"

echo $(mysql -e "SHOW GRANTS FOR khr_user;")
mysql -e "GRANT ALL ON khr_database.* TO 'khr_user'@'%';"
echo $(mysql -e "SHOW GRANTS FOR khr_user;")

echo "Star to giving my user permission"

echo "Start creating tables in khr_database"

echo $(mysql -e "SHOW TABLES IN khr_database;")
mysql -e "CREATE TABLE khr_database.todo_list (item_id INT AUTO_INCREMENT, content VARCHAR(255), PRIMARY KEY(item_id));"
echo $(mysql -e "SHOW TABLES IN khr_database;")

echo "End creating tables in khr_database"

echo "Start to insert text into todo_list table"

echo $(mysql -e "SELECT * FROM khr_database.todo_list;")
mysql -e "INSERT INTO khr_database.todo_list (content) VALUES ('Hi');"
mysql -e "INSERT INTO khr_database.todo_list (content) VALUES ('How are you?');"
mysql -e "INSERT INTO khr_database.todo_list (content) VALUES ('Goodbye');"
echo $(mysql -e "SELECT * FROM khr_database.todo_list;")

echo"End to insert text into todo_list table"

echo "Start adding todo_list.php"

cat << 'EOF' > /var/www/khr_domain/todo_list.php
<?php
$user = "khr_user";
$password = "123";
$database = "khr_database";
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
