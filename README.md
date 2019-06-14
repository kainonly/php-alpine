# PHP Alpine

The PHP FPM Service Docker Image

![MicroBadger Size](https://img.shields.io/microbadger/image-size/kainonly/php-alpine.svg?style=flat-square)
![MicroBadger Layers](https://img.shields.io/microbadger/layers/kainonly/php-alpine.svg?style=flat-square)
![Docker Pulls](https://img.shields.io/docker/pulls/kainonly/php-alpine.svg?style=flat-square)
![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/kainonly/php-alpine.svg?style=flat-square)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/kainonly/php-alpine.svg?style=flat-square)

```shell
docker pull kainonly/php-alpine
```

> PHP Extensions: calendar. bz2. zip. soap. sockets. iconv. exif. gmp. bcmath. enchant. xmlrpc. xsl. mysqli. pdo_mysql. pgsql. pdo_pgsql. opcache. gd. redis. mongodb. msgpack.

## Docker Compose

```yml
version: '3.7'
services:
  php:
    image: kainonly/php-alpine
    restart: always
    privileged: true
    sysctls:
      kernel.msgmnb: 65536
      kernel.msgmax: 65536
      kernel.shmmax: 68719476736
      kernel.shmall: 4294967296
      net.core.somaxconn: 65535
    volumes:
      - ./php/www.conf:/usr/local/etc/php-fpm.d/www.conf
      - ./php/php.ini:/usr/local/lib/php.ini
      - /home/website:/website
```

- `/usr/local/etc/php-fpm.d/` Extra Config
- `/usr/local/lib/php.ini` php.ini
- `/website` work directory

## With Nginx Docker Compose

```yml
version: '3.7'
services:
  nginx:
    image: kainonly/nginx-alpine
    restart: always
    privileged: true
    sysctls:
      net.ipv4.ip_forward: 0
      net.ipv4.conf.default.rp_filter: 1
      net.ipv4.conf.default.accept_source_route: 0
      net.ipv4.tcp_syncookies: 1
      kernel.msgmnb: 65536
      kernel.msgmax: 65536
      kernel.shmmax: 68719476736
      kernel.shmall: 4294967296
      net.core.somaxconn: 65535
      net.ipv4.tcp_synack_retries: 1
      net.ipv4.tcp_syn_retries: 1
      net.ipv4.tcp_fin_timeout: 1
      net.ipv4.tcp_keepalive_time: 30
      net.ipv4.ip_local_port_range: 1024 65000
    volumes:
      - socket:/var/run
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/vhost:/etc/nginx/vhost
      - ./nginx/logs:/var/nginx
      - /website:/website
    ports:
      - 80:80
      - 443:443
  php:
    image: kainonly/php-alpine
    restart: always
    privileged: true
    sysctls:
      kernel.msgmnb: 65536
      kernel.msgmax: 65536
      kernel.shmmax: 68719476736
      kernel.shmall: 4294967296
      net.core.somaxconn: 65535
    volumes:
      - socket:/var/run
      - ./php/www.conf:/usr/local/etc/php-fpm.d/www.conf
      - ./php/php.ini:/usr/local/lib/php.ini
      - /website:/website

volumes: 
  socket:
```

## Edit Config

www.conf

```conf
listen = /var/run/php-fpm.sock
listen.mode = 0666
```

php.ini

```ini
extension=redis.so
extension=msgpack.so
extension=mongodb.so
```

## ex.Laravel Deployment

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

	http2_body_preread_size 128k;
	http2_chunk_size 16k;
	ssl_certificate vhost/developer.com/site.crt;
	ssl_certificate_key vhost/developer.com/site.key;
	ssl_session_cache shared:SSL:20m;
	ssl_session_timeout 10m;
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
	ssl_prefer_server_ciphers on;
	ssl_ciphers ECDH+AESGCM:ECDH+AES256:ECDH+AES128:DH+3DES:!ADH:!AECDH:!MD5;

	root /website/developer.com/public;
	index index.html index.htm index.php;

	location / {
		aio threads=default;
		try_files $uri $uri/ /index.php?$query_string;
	}

	location ~* .(jpg|jpeg|png|gif|ico|css|js)$ {
		expires 365d;
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