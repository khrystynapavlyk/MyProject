#---------------------------------------------------------------------------
# Dockefile to build Docker Image of Apache WebServer running on Ubuntu
#---------------------------------------------------------------------------

FROM ubuntu:18.04

RUN apt-get -y update
RUN apt-get -y install apache2

COPY index.html /var/www/html/index.html

CMD ["/usr/sbin/apache2ctl", "-D","FOREGROUND"]
EXPOSE 80
