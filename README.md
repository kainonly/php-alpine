# PHP Alpine

The PHP FPM Service Docker Image

![MicroBadger Size](https://img.shields.io/microbadger/image-size/kainonly/php-alpine.svg?style=flat-square)
![MicroBadger Layers](https://img.shields.io/microbadger/layers/kainonly/php-alpine.svg?style=flat-square)
![Docker Pulls](https://img.shields.io/docker/pulls/kainonly/php-alpine.svg?style=flat-square)
[![Github Actions](https://img.shields.io/github/workflow/status/docker-maker/php-alpine/release?style=flat-square)](https://github.com/docker-marker/php-alpine/actions)

```shell
docker pull kainonly/php-alpine
```

> **PHP Extensions:** calendar. bz2. zip. soap. sockets. iconv. exif. gmp. bcmath. enchant. xmlrpc. xsl. mysqli. pdo_mysql. pgsql. pdo_pgsql. opcache. gd. redis. mongodb. msgpack.

## Docker Compose

```yml
version: '3.7'
services:
  php:
    image: kainonly/php-alpine
    restart: always
    volumes:
      - ./php/php.ini:/usr/local/etc/php/php.ini
      - ./php/www.conf:/usr/local/etc/php-fpm.d/www.conf
      - /home/website:/website
```

- `/usr/local/etc/php/php.ini` PHP INI
- `/usr/local/etc/php-fpm.d/` Extra Config
- `/website` work directory

## With Nginx Docker Compose

```yml
version: '3.8'
services:
  nginx:
    image: kainonly/nginx-alpine
    restart: always
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/vhost:/etc/nginx/vhost
      - ./nginx/log:/var/log/nginx
      - ./nginx/cache:/var/cache/nginx
      - ./run:/var/run
      - /website:/website
    ports:
      - 80:80
      - 443:443
  php:
    image: kainonly/php-alpine
    restart: always
    volumes:
      - ./php/php.ini:/usr/local/etc/php/php.ini
      - ./php/www.conf:/usr/local/etc/php-fpm.d/www.conf
      - ./php/cacert.pem:/usr/local/etc/php/cacert.pem
      - ./run:/var/run
      - /website:/website

```

## Edit Config

./php/www.conf

```conf
....

user = www-data
group = www-data

listen = /var/run/php-fpm.sock
listen.mode = 0666
listen.backlog = -1

rlimit_files = 65535

....
```

./php/php.ini

```ini
engine = On
expose_php = Off
short_open_tag = Off
realpath_cache_size = 2M
max_execution_time = 86400
memory_limit = 128M
error_reporting = 0
display_errors = 0
display_startup_errors = 0
log_errors = 0
default_charset = "UTF-8"
sys_temp_dir = /tmp

[opcache]
opcache.enable=1
opcache.enable_cli=0
opcache.memory_consumption=512
opcache.interned_strings_buffer=32
opcache.max_accelerated_files=10000

[curl]
curl.cainfo = /usr/local/etc/php/cacert.pem
```

## Laravel Deployment

create `./nginx/vhost/developer.com/site.conf`

```conf
server {
    listen  80;
    server_name developer.com;
    rewrite ^(.*)$  https://$host$1 permanent;
}

server {
    listen 443 ssl http2;
    server_name developer.com;
    
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";
    
    ssl_certificate vhost/<......>/site.crt;
    ssl_certificate_key vhost/<......>/site.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    
    root /website/developer.com/public;
    index index.html index.htm index.php;
    
    location / {
        aio threads=default;
        try_files $uri $uri/ /index.php?$query_string;
    }
    
    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }
    
    error_page 404 /index.php;
    
    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }
    
    location ~ /\.(?!well-known).* {
        deny all;
    }
}
```