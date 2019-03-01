## PHP-Alpine

PHP's custom image

Docker Pull Command

```shell
docker pull kainonly/php-alpine:7.3.2
```

Set docker-compose

```yaml
version: '3.7'
services:
  php:
    image: kainonly/php-alpine:7.3.2
    restart: always
    volumes:
      - ./website:/var/www/html
    ports:
      - 9000:9000
```

volumes

- `/var/www/html` Virtual directory
