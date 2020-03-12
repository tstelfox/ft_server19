# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Dockerfile                                         :+:    :+:             #
#                                                      +:+                     #
#    By: tmullan <tmullan@student.codam.nl>           +#+                      #
#                                                    +#+                       #
#    Created: 2020/03/05 14:16:52 by tmullan        #+#    #+#                 #
#    Updated: 2020/03/11 20:14:30 by tmullan       ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

#setting up OS
FROM debian:buster
RUN apt-get update
RUN	apt-get upgrade
#installing nginx, mariadb, php

RUN	apt-get install nginx -y

RUN apt-get install mariadb-server mariadb-client -y

RUN apt-get install php-fpm php-mysql -y


#Runs all necessary files
COPY ./srcs/nginx.sh .
COPY ./srcs/nginx.conf /etc/nginx/sites-available/default
COPY ./srcs/info.php /var/www/localhost/info.php


CMD bash nginx.sh && tail -f /dev/null
