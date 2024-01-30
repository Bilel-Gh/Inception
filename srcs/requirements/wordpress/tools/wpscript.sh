#!/bin/bash
#set -eux

cd /var/www/html/wordpress

# Set the correct ownership and permissions
chown -R www-data:www-data /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress

# Check if wp-config.php exists
if [ ! -f wp-config.php ]; then
    echo "Debug: wp-config.php not found. Creating..."
    wp config create --allow-root --dbname=${SQL_DATABASE} \
        --dbuser=${SQL_USER} \
        --dbpass=${SQL_PASSWORD} \
        --dbhost=${SQL_HOST} \
        --url=https://${DOMAIN_NAME}

    # Check the exit status of the wp config create command
    if [ $? -ne 0 ]; then
        echo "Error: Database connection error ($?). Host '${SQL_HOST}' might not be allowed to connect."
        exit 1
    fi

    # Sleep for a few seconds to allow wp-config.php to be created
    sleep 5
fi

if ! wp core is-installed --allow-root; then
    wp core install --allow-root \
        --url=https://${DOMAIN_NAME} \
        --title=${SITE_TITLE} \
        --admin_user=${ADMIN_USER} \
        --admin_password=${ADMIN_PASSWORD} \
        --admin_email=${ADMIN_EMAIL}

    wp user create --allow-root \
        ${USER1_LOGIN} ${USER1_MAIL} \
        --role=author \
        --user_pass=${USER1_PASS}

    wp cache flush --allow-root

    # Set the site language to French
    wp language core install fr_FR --activate --allow-root

    # Remove default themes and plugins
    wp plugin delete hello --allow-root

    # Set the permalink structure to "Plain"
    wp rewrite structure '/' --allow-root

    # Flush rewrite rules to apply changes
    wp rewrite flush --hard --allow-root
fi

if [ ! -d /run/php ]; then
    mkdir /run/php
fi

# Start the PHP FastCGI Process Manager (FPM) for PHP version 7.4 in the foreground
exec /usr/sbin/php-fpm7.4 -F -R
