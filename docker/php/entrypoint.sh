#!/bin/sh
set -e
cd /var/www/html

if [ "$RUN_SETUP" = "true" ]; then
  if [ -f artisan ]; then
    [ -d vendor ] || composer install --no-interaction --prefer-dist
    [ -f .env ] || cp .env.example .env
    grep -q '^APP_KEY=base64' .env || php artisan key:generate --force
    php artisan migrate --force
    php artisan db:seed --force          # los seeders deben ser idempotentes
    php artisan storage:link || true
    chmod -R 777 storage bootstrap/cache  # solo desarrollo
  else
    echo "No existe el proyecto Laravel en src/ (ver tarea T-01)"
  fi
  touch /tmp/ready
fi

exec "$@"
