# Use Debian 11 as the base image
FROM debian:11

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install mariadb-server -y
RUN apt-get install mariadb-client -y

# COPY /conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY /conf/my.cnf /etc/mysql/

COPY /tools/mdb_configure.sh /tmp/mdb_configure.sh
RUN chmod +x /tmp/mdb_configure.sh

ENTRYPOINT ["/tmp/mdb_configure.sh"]