#!/bin/bash
#set -eux

cd /var/www/html/wordpress

if ! wp core is-installed --allow-root; then
wp config create	--allow-root --dbname=${SQL_DATABASE} \
            --dbuser=${SQL_USER} \
            --dbpass=${SQL_PASSWORD} \
            --dbhost=${SQL_HOST} \
            --url=https://${DOMAIN_NAME};

wp core install	--allow-root \
            --url=https://${DOMAIN_NAME} \
            --title=${SITE_TITLE} \
            --admin_user=${ADMIN_USER} \
            --admin_password=${ADMIN_PASSWORD} \
            --admin_email=${ADMIN_EMAIL};

wp user create		--allow-root \
            ${USER1_LOGIN} ${USER1_MAIL} \
            --role=author \
            --user_pass=${USER1_PASS} ;

wp cache flush --allow-root

# it provides an easy-to-use interface for creating custom contact forms and managing submissions, as well as supporting various anti-spam techniques
wp plugin install contact-form-7 --activate --allow-root

# set the site language to English
wp language core install fr_FR --activate --allow-root

# remove default themes and plugins
wp theme delete twentynineteen twentytwenty --allow-root
wp plugin delete hello --allow-root

# set the permalink structure
wp rewrite structure '/%postname%/' --allow-root

fi

if [ ! -d /run/php ]; then
    mkdir /run/php;
fi

# start the PHP FastCGI Process Manager (FPM) for PHP version 7.3 in the foreground
exec /usr/sbin/php-fpm7.3 -F -R
