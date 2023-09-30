#!/bin/bash

if service mysql start; then

    echo "INFO: Started MariaDB as a background service "
    echo "INFO: Changing config"
    sleep 5

    mysql -u root -p"$DB_ROOT_PASSWORD" < /tmp/init.sql


    echo "INFO: Initialized MariaDB system tables and created database and user."

    # Stop MariaDB
    if mysqladmin -u root -p$DB_ROOT_PASSWORD shutdown; then
        echo "INFO: Stopped MariaDB as a background service"
    else
        echo "ERROR: Failed to stop MariaDB service."
    fi
else
    echo "ERROR: Failed to start MariaDB service."
fi

# Optionally, you can start the service again here if needed
mysqld -u root --bind-address=0.0.0.0

