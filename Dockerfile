# Dockerfile used to create an Apache/PHP environment for PHP sites
# includes awscli, and

FROM php:7-apache
MAINTAINER Randy Hommel <randy@hommel.name>

ENV TZ America/Los_Angeles

EXPOSE 80 

WORKDIR /var/www/html
ENTRYPOINT /opt/conf/entrypoint.sh

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y php5-mcrypt libmcrypt-dev vim zlib1g-dev python-pip

RUN pip install --upgrade pip && \
    pip install awscli

RUN apt-get install -y libpng12-dev libjpeg-dev
RUN apt-get autoremove -y

RUN docker-php-ext-configure zip && \
    docker-php-ext-install   zip
RUN docker-php-ext-configure mysqli && \
    docker-php-ext-install   mysqli
RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/local && \
    docker-php-ext-install   gd

RUN echo "set nocompatible" > /root/.vimrc

RUN a2enmod headers
RUN a2enmod rewrite

ADD entrypoint.sh /opt/conf/entrypoint.sh
