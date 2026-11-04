ARG PHP_VERSION=8.5
FROM php:${PHP_VERSION}-fpm

RUN apt-get update && apt-get install -y --no-install-recommends \
      git unzip libicu-dev libzip-dev libpng-dev libjpeg-dev libfreetype-dev libwebp-dev \
 && rm -rf /var/lib/apt/lists/*

# Extensiones esenciales, instaladas una por una para evitar fallos de compilación paralela
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install zip

# GD necesita configuración previa por sus librerías de imagen
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
 && docker-php-ext-install gd

# intl se instala por separado
RUN docker-php-ext-install intl

# Falla la construcción si PHP está por debajo de la versión mínima segura
RUN php -r 'if (version_compare(PHP_VERSION, "8.5.12", "<")) { fwrite(STDERR, "PHP ".PHP_VERSION." es inseguro. Se requiere >= 8.5.12\n"); exit(1); }'

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html
ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm"]
