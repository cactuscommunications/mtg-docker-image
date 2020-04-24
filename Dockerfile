FROM php:5.6-apache

ENV DEBIAN_FRONTEND noninteractive

# Dependencies
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash && \ 
    apt-get update && apt-get install -y \
    make gcc g++ build-essential git unzip zlib1g-dev\
    inkscape \
    libmagickcore-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    unoconv \
    npm nodejs

# Fonts
RUN curl -sLO https://github.com/google/fonts/archive/master.zip
RUN unzip master.zip && \
    rm master.zip && \
    cp -rvf fonts-master /usr/share/fonts && \
    fc-cache -fv && \
    rm -Rf fonts-master

WORKDIR /var/www/

# PHP Extensions and Composer
RUN pecl install imagick && docker-php-ext-enable imagick
RUN docker-php-ext-install zip mcrypt mysqli gd
RUN curl -s http://getcomposer.org/installer | php

# PHP ini config
RUN echo '\nmemory_limit=512M\nupload_max_filesize=64M\npost_max_size=64M\nmax_execution_time=6000\ndefault_socket_timeout=6000\nmysql.connect_timeout=6000' > /usr/local/etc/php/conf.d/99-mtg-configs.ini

# Libreoffice config
RUN sed -i 's;Logo=1;Logo=0;g' /etc/libreoffice/sofficerc

# Clear apt source lists
RUN rm -rf /var/lib/apt/lists/*

RUN usermod -u 1000 www-data

EXPOSE 80