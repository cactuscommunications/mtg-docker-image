FROM "php:5.6-fpm"

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash

RUN apt-get update && apt-get install -y \
    make gcc g++ build-essential git unzip zlib1g-dev automake\
    inkscape \
    libmagickcore-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    unoconv \
    ffmpeg \
    npm nodejs \
    nginx \
    supervisor


WORKDIR /var/www/

# PHP Extensions and Composer
RUN pecl channel-update pecl.php.net
RUN pecl install redis-2.2.8 && docker-php-ext-enable redis
RUN pecl install imagick && docker-php-ext-enable imagick
RUN docker-php-ext-install zip mcrypt mysqli gd
RUN curl -s http://getcomposer.org/installer | php