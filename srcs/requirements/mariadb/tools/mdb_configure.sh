#!/bin/bash

print_error_log() {
    # Get the initial size of the error log
    LOG_SIZE=$(stat -c %s /var/log/faillog)

    while true; do
        # Get the current size of the error log
        CURRENT_SIZE=$(stat -c %s /var/log/faillog)

        # If the log file has grown since the last check, print new entries
        if [ $CURRENT_SIZE -gt $LOG_SIZE ]; then
            echo "-------------------------------------------------"
            tail -c +$LOG_SIZE /var/log/mysql/error.log | grep -v '^$'
            LOG_SIZE=$CURRENT_SIZE
        fi

        # Sleep for a short duration before checking again
        sleep 1
    done
}

if service mariadb start; then

    echo "INFO: Started MariaDB as a background service "

    echo "-------------------------------------------------"

    echo "INFO: Changing 50-server.cnf"

    sed -i "s|skip-networking|# skip-networking|g" /etc/mysql/mariadb.conf.d/50-server.cnf
    sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/mysql/mariadb.conf.d/50-server.cnf

    echo "INFO: Changed 50-server.cnf"
    
    echo "-------------------------------------------------"

    echo "INFO: Changing my.cnf"

    sed -i '/\[client-server\]/a\
            port = 3306\n\
            # socket = /run/mysqld/mysqld.sock\n\
            \n\
            !includedir /etc/mysql/conf.d/\n\
            !includedir /etc/mysql/mariadb.conf.d/\n\
            \n\
            [mysqld]\n\
            user = root\n\
            \n\
            [server]\n\
            bind-address = 0.0.0.0' /etc/mysql/my.cnf

    echo "INFO: Changed my.cnf"

    echo "-------------------------------------------------"

    echo "INFO: Initializing database and user."

    # Create database if not exists
    mariadb -u root -p$DB_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $DB_DATABASE;"

    # Create user and grant privileges for '%' (any host)
    mariadb -u root -p$DB_PASSWORD -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
    mariadb -u root -p$DB_PASSWORD -e "GRANT ALL PRIVILEGES ON $DB_DATABASE.* TO '$DB_USER'@'%';"

    # Create user and grant privileges for 'localhost'
    mariadb -u root -p$DB_PASSWORD -e "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
    mariadb -u root -p$DB_PASSWORD -e "GRANT ALL PRIVILEGES ON $DB_DATABASE.* TO '$DB_USER'@'localhost';"

    mariadb -u root -p$DB_PASSWORD -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
    mariadb -u root -p$DB_PASSWORD -e "FLUSH PRIVILEGES;"

    mariadb -u root -p$DB_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$DB_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES;"

    echo "INFO: Initialized database and user."

    echo "-------------------------------------------------"

    echo "INFO: Stopping MariaDB as a background service"

    if mysqladmin -u root -p$DB_PASSWORD shutdown; then
        echo "INFO: Stopped MariaDB as a background service"
    else
        echo "ERROR: Failed to stop MariaDB service."
    fi
else
    echo "ERROR: Failed to start MariaDB service."
fi

echo "-------------------------------------------------"

echo "INFO: Starting Mariadb daemon"

print_error_log &

echo "MARIADB ERRORS:"
if mariadbd --bind-address=0.0.0.0; then
    echo "INFO: Started Mariadb daemon"
else
    echo "ERROR: Failed to start mariadb daemon"
fi

echo "-------------------------------------------------"
