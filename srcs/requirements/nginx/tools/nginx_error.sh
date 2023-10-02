#!/bin/sh

print_error_log() {
    # Get the initial size of the error log
    LOG_SIZE=$(stat -c %s /var/log/nginx/error.log)

    while true; do
        # Get the current size of the error log
        CURRENT_SIZE=$(stat -c %s /var/log/nginx/error.log)

        # If the log file has grown since the last check, print new entries
        if [ $CURRENT_SIZE -gt $LOG_SIZE ]; then
			echo "-------------------------------------------------"
            tail -c +$LOG_SIZE /var/log/nginx/error.log | grep -v '^$'
            LOG_SIZE=$CURRENT_SIZE
        fi

        # Sleep for a short duration before checking again
        sleep 1
    done
}

print_error_log & 

echo "INFO: Starting NGINX"
nginx -g "daemon off;"
echo "INFO: Started NGINX"