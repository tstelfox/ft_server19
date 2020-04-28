# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Dockerfile                                         :+:    :+:             #
#                                                      +:+                     #
#    By: tmullan <tmullan@student.codam.nl>           +#+                      #
#                                                    +#+                       #
#    Created: 2020/03/05 14:16:52 by tmullan       #+#    #+#                  #
#    Updated: 2020/04/28 11:04:32 by tmullan       ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

#setting up OS
FROM debian:buster
RUN apt-get update
RUN	apt-get upgrade -y
RUN apt-get install wget -y

#installing nginx, mariadb, php
RUN	apt-get install nginx -y
RUN apt-get install php7.3 php-fpm php-zip php-mysql php-mbstring php-cli php-curl php-gd php-intl php-soap php-xml php-xmlrpc -y
RUN apt-get install mariadb-server -y
RUN apt-get install sendmail -y

#copies all necessary source files
COPY ./srcs/nginx.conf /etc/nginx/sites-available/localhost
COPY ./srcs/sqlsetup.sql /var/

#Generate SSl certificate here
RUN openssl genrsa -out /etc/ssl/certs/localhost.key 2048 && \
	openssl req -x509 -days 356 -nodes -new -key /etc/ssl/certs/localhost.key \
	-subj '/C=NL/ST=NH/L=Amsterdam/O=Codam/CN=localhost' -out /etc/ssl/certs/localhost.crt

#linking
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost && nginx -t

#installing phpmyadmin
WORKDIR /var/www/html
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar xf phpMyAdmin-5.0.1-english.tar.gz && rm phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english phpmyadmin
COPY ./srcs/config.inc.php phpmyadmin

#installing wordpress
RUN wget https://wordpress.org/latest.tar.gz 
RUN tar xf latest.tar.gz && rm latest.tar.gz
RUN mv wordpress/* /var/www/html

#preconfiguring wordpress
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp 
RUN service mysql start && \
	wp core config --allow-root --dbname=wordpress_db --dbuser=root --dbpass= --dbhost=localhost --dbprefix=wp_ && \
    echo "define( 'WP_DEBUG', true );" >> /var/www/html/wp-config.php && \
    echo "define( 'WP_DEBUG_LOG', true );" >> /var/www/html/wp-config.php && \
    wp db create --allow-root && \
    wp core install --allow-root --url=https://localhost --title=AmonRA --admin_user=mumyer --admin_password=password --admin_email=duke1199sp@gmail.com 

#increasing max file size
RUN	sed -i '/upload_max_filesize/c upload_max_filesize = 20M' /etc/php/7.3/fpm/php.ini
RUN	sed -i '/post_max_size/c post_max_size = 21M' /etc/php/7.3/fpm/php.ini

#configuration of root user privileges
RUN service mysql start && mysql -u root && mysql < /var/sqlsetup.sql \
	&& mysql -u root mysql < /var/www/html/phpmyadmin/sql/create_tables.sql

#fucking changing ownership fuck
RUN chown -R www-data:www-data /var/www
RUN chmod 755 -R /var/www

#I cmd u
CMD service php7.3-fpm start && \
	service nginx start && \
	service mysql start && \
	bash
	# tail -f /dev/null
EXPOSE 80 443
