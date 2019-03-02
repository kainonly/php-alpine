## PHP-Alpine

Docker Pull Command

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
