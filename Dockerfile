FROM php:5.5-fpm-alpine

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk add --no-cache \
    freetype \
    libjpeg-turbo \
    libpng \
    libwebp \
    libxpm \
    libbz2 \
    bzip2 \
    libxml2 \
    gmp \
    enchant \
    libxslt \
    libmcrypt

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libxpm-dev \
    bzip2-dev \
    libxml2-dev \
    gmp-dev \
    enchant-dev \
    libxslt-dev \
    libmcrypt-dev \
    \
    && docker-php-ext-install \
    \
    calendar \
    bz2 \
    soap \
    sockets \
    iconv \
    exif \
    gmp \
    bcmath \
    mcrypt \
    enchant \
    xmlrpc \
    xsl \
    mysql \
    mysqli \
    pdo_mysql \
    opcache \
    \
    && docker-php-ext-configure gd --with-freetype-dir --with-jpeg-dir --with-png-dir --with-webp-dir --with-xpm-dir \ 
    && docker-php-ext-install gd \
    && pecl install redis-4.3.0 \
    && docker-php-ext-enable redis \
    \
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
