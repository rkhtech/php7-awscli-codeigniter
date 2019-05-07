# Dockerfile used to create an Apache/PHP environment for PHP sites
# includes awscli, and

FROM php:5.6-apache
MAINTAINER Randy Hommel <randy@hommel.name>

ENV TZ America/Los_Angeles

#port 81 is solely for redirecting non-https traffic
EXPOSE 80 81

WORKDIR /var/www/html
ENTRYPOINT /opt/conf/entrypoint.sh

ADD bashrc /root/.bashrc
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y vim zlib1g-dev python3 libpng-dev libjpeg-dev unzip zip
RUN curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
RUN python3 /tmp/get-pip.py

RUN pip install --upgrade pip && \
    pip install awscli

RUN apt-get autoremove -y

RUN docker-php-ext-configure zip && \
    docker-php-ext-install   zip
RUN docker-php-ext-configure mysqli && \
    docker-php-ext-install   mysqli
RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/local && \
    docker-php-ext-install   gd
RUN docker-php-ext-configure exif && \
    docker-php-ext-install   exif
RUN docker-php-ext-configure opcache && \
    docker-php-ext-install   opcache


RUN echo "set nocompatible" > /root/.vimrc

RUN a2enmod headers
RUN a2enmod rewrite

RUN touch /var/log/apache2/php-errors.log
RUN chown www-data:www-data /var/log/apache2/php-errors.log
ADD php_ini/phperrors.ini /usr/local/etc/php/conf.d/phperrors.ini
ADD php_ini/phpuploads.ini /usr/local/etc/php/conf.d/phpuploads.ini

ADD entrypoint.sh /opt/conf/entrypoint.sh
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN echo 'Listen 81' >> /etc/apache2/ports.conf
RUN echo "ok" > /var/www/html/index.html

