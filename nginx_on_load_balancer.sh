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

echo "Start to create an Nginx virtual host configuration file to implement the load balancer"
cat << 'EOF' > /etc/nginx/conf.d/loadbalancer.conf
upstream backend {
        server ip_server1;
        server ip_server2;
    }

    server {
        listen      80;
        server_name ip_server_lb;

        location / {
	        proxy_redirect      off;
	        proxy_set_header    X-Real-IP $remote_addr;
	        proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
	        proxy_set_header    Host $http_host;
		proxy_pass http://backend;
	}
}

EOF
echo "End to create an Nginx virtual host configuration file to implement the load balancer"

echo "Start to modify ip_server1 "
sed -i "s/ip_server1/$1/g" /etc/nginx/conf.d/loadbalancer.conf
echo "End to modify ip_server1"

echo "Start to modify ip_server2"
sed -i "s/ip_server2/$2/g" /etc/nginx/conf.d/loadbalancer.conf
echo "End to modify ip_server2"

echo "Start to modify ip_server_lb"
sed -i "s/ip_server_lb/$3/g" /etc/nginx/conf.d/loadbalancer.conf
echo "End to modify ip_server_lb"

echo "Start systemctl restart nginx"
sudo systemctl restart nginx
echo "End systemctl restart nginx"
