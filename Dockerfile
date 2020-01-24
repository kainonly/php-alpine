FROM php:7.4.2-fpm-alpine

RUN apk add --no-cache \
    freetype \
    libjpeg-turbo \
    libpng \
    bzip2 \
    libzip \
    libxml2 \
    gmp \
    enchant \
    openssl

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    bzip2-dev \
    libzip-dev \
    libxml2-dev \
    gmp-dev \
    enchant-dev \
    openssl-dev \
    \
    && docker-php-ext-install \
    \
    ffi \
    calendar \
    bz2 \
    zip \
    pcntl \
    soap \
    iconv \
    exif \
    gmp \
    bcmath \
    enchant \
    sockets \
    mysqli \
    pdo_mysql \
    opcache \
    \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \ 
    && docker-php-ext-install -j$(nproc) gd \
    \
    && pecl install redis msgpack \
    && docker-php-ext-enable redis msgpack \
    && apk del .build-deps

RUN rm -rf /var/www/html \
    && mkdir -p /website \
    && chown www-data:www-data /website \
    && chmod 777 /website \
    && { \
    echo '[global]'; \
    echo 'daemonize = no'; \
    } | tee /usr/local/etc/php-fpm.d/zz-docker.conf

WORKDIR /website
