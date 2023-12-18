FROM debian:buster

RUN apt update -y && apt upgrade -y
RUN apt-get -y install wget
RUN apt-get install -y php7.3 php-fpm php-mysql
RUN apt-get install -y mariadb-client

# a command-line interface for WordPress, you can manage WordPress once it's downloaded
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

RUN apt-get update && apt-get install -y default-mysql-client
RUN wget https://fr.wordpress.org/wordpress-6.4.2-fr_FR.tar.gz -P /var/www/html
RUN cd /var/www/html && tar -xvf wordpress-6.4.2-fr_FR.tar.gz && rm -rf wordpress-6.4.2-fr_FR.tar.gz

# ensure that the web server(nginx) has the necessary permissions to read and execute the files within the web root directory
RUN	chown -R www-data:www-data /var/www/*
RUN	chmod -R 755 /var/www/*

EXPOSE 9000

COPY ./tools/wpscript.sh ./
RUN chmod +x ./wpscript.sh

COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

ENTRYPOINT ["bash", "./wpscript.sh"]
