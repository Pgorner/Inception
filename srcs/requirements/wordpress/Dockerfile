FROM debian:11

RUN apt update && apt upgrade -y

ENV PHP_VERSION=7.4

# Install necessary software
RUN apt-get update \
    && apt-get install -y \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-common \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-xml -y\
    php${PHP_VERSION}-zip \
    mariadb-client \
    wget \
    unzip

RUN apt-get install curl -y

RUN mkdir -p /var/www/html/
WORKDIR /var/www/html/

COPY ./tools/configure.sh /tmp/configure.sh
RUN chmod +x /tmp/configure.sh

ENTRYPOINT ["/tmp/configure.sh"]
