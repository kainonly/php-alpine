FROM php:7.4.33-fpm-buster

# Debian Buster 已 EOL，切换到归档源
RUN echo "deb http://archive.debian.org/debian buster main" > /etc/apt/sources.list \
    && echo "deb http://archive.debian.org/debian-security buster/updates main" >> /etc/apt/sources.list

# ---------- runtime 依赖 ----------
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libfreetype6 \
    libjpeg62-turbo \
    libpng16-16 \
    libbz2-1.0 \
    libzip4 \
    libxml2 \
    libgmp10 \
    zlib1g \
    libyaml-0-2 \
    libssh2-1 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# ---------- build 依赖 ----------
RUN apt-get update && apt-get install -y --no-install-recommends \
    $PHPIZE_DEPS \
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
    \
    && apt-get purge -y --auto-remove $PHPIZE_DEPS \
    && rm -rf /var/lib/apt/lists/*

# ---------- runtime layout ----------
RUN rm -rf /var/www/html \
    && mkdir -p /website \
    && chown www-data:www-data /website \
    && chmod 777 /website \
    && { \
    echo '[global]'; \
    echo 'daemonize = no'; \
    } > /usr/local/etc/php-fpm.d/zz-docker.conf

WORKDIR /website