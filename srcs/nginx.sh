# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    nginx.sh                                           :+:    :+:             #
#                                                      +:+                     #
#    By: tmullan <tmullan@student.codam.nl>           +#+                      #
#                                                    +#+                       #
#    Created: 2020/03/05 15:10:16 by tmullan        #+#    #+#                 #
#    Updated: 2020/03/11 20:15:58 by tmullan       ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

nginx
service php7.3-fpm start

/etc/init.d/mysql start

# mkdir /var/www/localhost
chown -R $USER:$USER /var/www/localhost
# rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/
