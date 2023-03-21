# syntax=docker/dockerfile:1.3-labs

FROM php:7.4-apache-buster

ARG DEBIAN_FRONTEND=noninteractive

#Installing PHP modules

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions
RUN install-php-extensions mysqli gd zip imagick intl

#Enabling rewrite and ssl modules

RUN if [ -n "$( (cat /etc/apache2/mods-available | grep rewrite) )" ]; then a2enmod rewrite; fi
RUN if [ -n "$( (cat /etc/apache2/mods-available | grep ssl) )" ]; then a2enmod ssl; fi

#Configuring the Apache directory

RUN adduser root www-data
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R g+rw /var/www/html
COPY index.php /var/www/html