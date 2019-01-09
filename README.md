## PHP-Alpine

PHP's minimalist custom image

- size `130` mb
- version `7.2.13`

Docker Pull Command

```shell
docker pull kainonly/php-alpine
```

Set docker-compose

```yaml
version: '3'
services:
  php:
    image: kainonly/php-alpine:7.2.13
    restart: always
    volumes:
      - ./website:/website
    ports:
      - 9000:9000
```

volumes

- `/website` Virtual directory