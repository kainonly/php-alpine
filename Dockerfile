FROM php:fpm-alpine

RUN apk add --no-cache \
    freetype \
    libjpeg-turbo \
    libpng \
    libwebp \
    libxpm \
    bzip2 \
    libzip \
    libxml2 \
    gmp \
    enchant \
    libxslt \
    imagemagick

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libxpm-dev \
    bzip2-dev \
    libzip-dev \
    libxml2-dev \
    gmp-dev \
    enchant-dev \
    libxslt-dev \
    imagemagick-dev \
    \
    && docker-php-ext-install \
    \
    calendar \
    bz2 \
    zip \
    soap \
    sockets \
    exif \
    gmp \
    bcmath \
    enchant \
    xmlrpc \
    xsl \
    mysqli \
    pdo_mysql \
    opcache \
    \
    && docker-php-ext-configure gd --with-freetype-dir --with-jpeg-dir --with-png-dir --with-webp-dir --with-xpm-dir \ 
    && docker-php-ext-install gd \
    \
    && pecl install redis mongodb msgpack imagick \
    && docker-php-ext-enable redis mongodb msgpack imagick \
    && apk del .build-deps