-- Create database if not exists
CREATE DATABASE IF NOT EXISTS `wordpress_db`;

-- Create user and grant privileges for '%' (any host)
CREATE USER IF NOT EXISTS 'pgorner'@'%' IDENTIFIED BY '12345';
GRANT ALL PRIVILEGES ON `wordpress_db`.* TO 'pgorner'@'%';

-- Create user and grant privileges for 'localhost'
CREATE USER IF NOT EXISTS 'pgorner'@'localhost' IDENTIFIED BY '12345';
GRANT ALL PRIVILEGES ON `wordpress_db`.* TO 'pgorner'@'localhost';

-- Change root user password and flush privileges
ALTER USER 'root'@'localhost' IDENTIFIED BY 'admin12345';
FLUSH PRIVILEGES;
