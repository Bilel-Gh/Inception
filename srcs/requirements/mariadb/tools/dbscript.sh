#!/bin/bash
#set -eux

# start MariaDB

# Check if MariaDB is running
if ! service mariadb status; then
    # Start MariaDB service
    service mariadb start

    # Wait for MariaDB to start (you might need to adjust the sleep duration)
    sleep 10
fi

# log into MariaDB as root and create database and the user
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
mysql -e "ALTER USER 'root'@'%' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql -u root -p${SQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown
#mysqladmin -u root shutdown

exec mysqld_safe

#print status
echo "MariaDB database and user were created successfully! "