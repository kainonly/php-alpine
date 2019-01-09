FROM alpine:edge

ENV VERSION 7.2.13

RUN addgroup -g 82 -S nginx \
    && adduser -u 82 -D -S -h /var/cache/nginx -s -G nginx nginx \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk add --no-cache \
    php7 \
    php7-fpm \
    php7-common \
    php7-calendar \
    php7-bz2 \
    php7-zip \
    php7-session \
    php7-curl \
    php7-imap \
    php7-soap \
    php7-openssl \
    php7-ctype \
    php7-mcrypt \
    php7-sodium \
    php7-exif \
    php7-gd \
    php7-fileinfo \
    php7-gmp \
    php7-bcmath \
    php7-iconv \
    php7-mbstring \
    php7-enchant \
    php7-json \
    php7-yaml \
    php7-xml \
    php7-dom \
    php7-xmlrpc \
    php7-simplexml \
    php7-xmlreader \
    php7-xmlwriter \
    php7-xsl \
    php7-sqlite3 \
    php7-pgsql \
    php7-mysqli \
    php7-mysqlnd \
    php7-pdo \
    php7-pdo_sqlite \
    php7-pdo_mysql \
    php7-pdo_pgsql \
    php7-phar \
    php7-opcache \
    php7-pecl-imagick \
    php7-pecl-msgpack \
    php7-pecl-redis \
    php7-pecl-mongodb

COPY php-fpm.conf /usr/local/etc/php-fpm.conf
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

VOLUME /usr/local/etc/php-fpm.d

EXPOSE 9000

STOPSIGNAL SIGTERM

CMD ["php-fpm"]