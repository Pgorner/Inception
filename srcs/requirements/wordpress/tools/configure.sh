#!/bin/bash

# Wait for the database to become available
echo "INFO: Waiting for the database to become available..."
while ! mysqladmin ping -h"$MDB_HOSTNAME" -u"$MDB_USER" -p"$MDB_PASSWORD" --silent; do
    sleep 3
done
echo "INFO: Database is now available."

mkdir -p /run/php

curl -o /usr/local/bin/wp -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x /usr/local/bin/wp

echo "INFO: Downloading WP..."
# Download WordPress and configure database settings
wp core download --allow-root

wp config create --dbname="DATABASE" \
                 --dbuser="${DB_USER}" \
                 --dbpass="${DB_PASSWORD}" \
                 --dbhost="mariadb" \
                 --path="/var/www/html" \
                 --force \
                 --skip-check \
                 --allow-root

echo "INFO: Installing WordPress..."
wp core install --url="pgorner.42.fr" \
                --title="Inception" \
                --admin_user="${WP_ADMIN_USR}" \
                --admin_password="${WP_ADMIN_PWD}" \
                --admin_email="${WP_ADMIN_EMAIL}" \
                --allow-root


# Create a user if needed
if ! wp user list --allow-root | grep -q "$WP_USER_NAME"; then
    echo "INFO: Setting up ${WP_USER_NAME}"
    wp user create "${WP_USER_NAME}" \
                    "${WP_USER_EMAIL}" \
                    --user_pass="$WP_USER_PASSWORD" \
                    --allow-root
else
    echo "INFO: ${WP_USER_NAME} has already been set up"
fi

php-fpm${PHP_VERSION} -F
