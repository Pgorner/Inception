# Use Debian 11 as the base image
FROM debian:11

# Update the package list and install MariaDB
RUN apt update \
	&& apt upgrade -y \
	&& apt install mariadb-server -y

# Copy the configuration script to the container
COPY /tools/configure.sh /tmp/configure.sh
RUN chmod +x /tmp/configure.sh

COPY /conf/init.sql /tmp/init.sql
RUN chmod +x /tmp/init.sql

RUN mkdir -p /etc/mysql
RUN rm -f /etc/mysql/my.cnf
COPY ./conf/my.cnf /etc/mysql/

# Expose MySQL port (optional, depending on your use case)
EXPOSE 3306

# Entry point to run the configuration script
ENTRYPOINT ["/tmp/configure.sh"]