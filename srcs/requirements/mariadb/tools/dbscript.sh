#!/bin/bash
# set -eux

# Check if MariaDB is running
if ! service mariadb status; then
    # Start MariaDB service
    service mariadb start

    # Wait for MariaDB to start (you might need to adjust the sleep duration)
    sleep 10
fi

# log into MariaDB as root and create database and the user
mysql -u root --password="${SQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;" 2>/dev/null
mysql -u root --password="${SQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';" 2>/dev/null
mysql -u root --password="${SQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';" 2>/dev/null
mysql -e "GRANT ALL PRIVILEGES ON *.* TO root@localhost IDENTIFIED BY '12345';" 2>/dev/null
mysql -u root --password="${SQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;" 2>/dev/null

# Set the root password
mysqladmin -u root password "${SQL_ROOT_PASSWORD}"

# Flush privileges to apply changes
mysql -u root --password="${SQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;" 2>/dev/null

# Log the information
echo "MariaDB database and user were created successfully!"

# # Keep the script running
# tail -f /dev/null
