## PHP Alpine

The php-fpm service Docker Image containing PHP Common Extensions

![MicroBadger Size](https://img.shields.io/microbadger/image-size/kainonly/php-alpine.svg?style=flat-square)
![MicroBadger Layers](https://img.shields.io/microbadger/layers/kainonly/php-alpine.svg?style=flat-square)
![Docker Pulls](https://img.shields.io/docker/pulls/kainonly/php-alpine.svg?style=flat-square)
![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/kainonly/php-alpine.svg?style=flat-square)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/kainonly/php-alpine.svg?style=flat-square)

```shell
docker pull kainonly/php-alpine
```

Set docker-compose

```yaml
version: '3.7'
services:
  php:
    image: kainonly/php-alpine
    restart: always
    volumes:
      - ./php/www.conf:/usr/local/etc/php-fpm.d/www.conf
      - ./php/php.ini:/usr/local/lib/php.ini
      - /home/website:/website
```

- `/usr/local/etc/php-fpm.d/` extra config
- `/usr/local/lib/php.ini` php.ini
- `/website` Virtual directory
- `9000` php-fpm listen port

Version >= 7.0 Extensions:

- calendar
- bz2
- zip
- soap
- sockets
- iconv
- exif
- gmp
- bcmath
- enchant
- xmlrpc
- xsl
- mysqli
- pdo_mysql
- opcache
- gd
- redis
- mongodb
- msgpack

Version 5.x Extensions:

- calendar
- bz2
- zip
- soap
- sockets
- iconv
- exif
- gmp
- bcmath
- enchant
- xmlrpc
- xsl
- mysql
- mysqli
- pdo_mysql
- opcache
- gd
