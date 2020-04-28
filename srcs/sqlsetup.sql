CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;

GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost';

GRANT SELECT, INSERT, DELETE, UPDATE ON phpmyadmin.* TO 'root'@'localhost';

FLUSH PRIVILEGES;

update mysql.user set plugin = 'mysql_native_password' where user='root';

EXIT
