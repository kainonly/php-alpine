# syntax=docker/dockerfile:1

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

FROM --platform=$TARGETPLATFORM php:7.4.33-fpm

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

# Helpful log line to confirm the resolved platform during multi-arch builds
RUN echo "Building for platform: ${TARGETPLATFORM:-unknown} (OS: ${TARGETOS:-unknown}, Arch: ${TARGETARCH:-unknown})"

RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    libfreetype6 \
    libjpeg62-turbo \
    libpng16-16 \
    libbz2-1.0 \
    libzip4 \
    libxml2 \
    libgmp10 \
    zlib1g \
    libssl1.1 \
    libyaml-0-2 \
    libssh2-1 \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    $PHPIZE_DEPS \
    linux-libc-dev \
    make \
    automake \
    autoconf \
    gcc \
    g++ \
    zlib1g-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libbz2-dev \
    libzip-dev \
    libxml2-dev \
    libgmp-dev \
    libssl-dev \
    libyaml-dev \
    libssh2-1-dev \
    \
    && docker-php-ext-install \
    \
    calendar \
    bz2 \
    zip \
    pcntl \
    soap \
    iconv \
    exif \
    gmp \
    bcmath \
    sockets \
    mysqli \
    pdo_mysql \
    opcache \
    \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    \
    && pecl install redis msgpack ssh2-1.2 \
    && docker-php-ext-enable redis msgpack ssh2 \
    && apt-get purge -y --auto-remove $PHPIZE_DEPS \
    && rm -rf /var/lib/apt/lists/*

RUN rm -rf /var/www/html \
    && mkdir -p /website \
    && chown www-data:www-data /website \
    && chmod 777 /website \
    && { \
    echo '[global]'; \
    echo 'daemonize = no'; \
    } | tee /usr/local/etc/php-fpm.d/zz-docker.conf

WORKDIR /website