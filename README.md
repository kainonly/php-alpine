## PHP-Alpine

PHP's custom image

Docker Pull Command

```shell
docker pull kainonly/php-alpine
```

Set docker-compose

```yaml
version: '3'
services:
  php:
    image: kainonly/php-alpine:7.3.1
    restart: always
    volumes:
      - ./website:/var/www/html
    ports:
      - 9000:9000
```

volumes

- `/var/www/html` Virtual directory