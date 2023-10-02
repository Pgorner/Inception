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

echo "-------------------------------------------------"

echo "INFO: Changing NGINX configuration"

echo "server {\
    listen 443 ssl http2;\
    listen [::]:443 ssl http2;\
    server_name pgorner.42.fr;\
    root /var/www/html;\
    index index.php;\
\
    ssl_certificate /etc/nginx/ssl/ssl_final_cert.crt;\
    ssl_certificate_key /etc/nginx/ssl/ssl_priv_key.key;\
    ssl_protocols TLSv1.3;\
\
    location / {\
        try_files \$uri \$uri/ /index.php\$is_args\$args;\
    }\
\
    location ~ \.php$ {\
        include fastcgi_params; \
        fastcgi_pass wordpress:9000; \
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;\
    }\
\
    error_log /var/log/nginx/error.log;\
}" > /etc/nginx/conf.d/default.conf

echo "INFO: Changed NGINX configuration"

echo "-------------------------------------------------"

echo "INFO: Starting NGINX"
print_error_log & 

echo "NGINX ERRORS:"
nginx -g "daemon off;"
echo "INFO: Started NGINX"