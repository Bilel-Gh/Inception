# use debian as the base image
FROM debian:bullseye

# install MariaDB and other dependencies
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y mariadb-server
RUN apt-get install -y mariadb-client
RUN apt-get install -y procps


# copy the provided config file to the container
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN mkdir -p /var/run/mysqld
RUN mkdir -p /var/lib/mysql
RUN chown mysql:mysql /var/run/mysqld/
RUN chmod -R 755 /var/run/mysqld/
RUN chown mysql:mysql /var/lib/mysql/
RUN chmod -R 755 /var/lib/mysql/

EXPOSE 3306

COPY ./tools/dbscript.sh ./
RUN chmod +x ./dbscript.sh

COPY ./tools/init.sql /usr/local/bin/init.sql
RUN chmod +x /usr/local/bin/init.sql

ENTRYPOINT ["./dbscript.sh"]

#Command to launch mariadb and enable the database to listen globally - also can be put on mysqldump.cnf file
CMD ["mysqld", "--bind-address=0.0.0.0", "--init-file=/usr/local/bin/init.sql", "/usr/bin/mysqld_safe"]

