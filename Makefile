up:
	docker compose build --pull
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

shell:
	docker compose exec app bash

test:
	docker compose exec app php artisan test

fresh:
	docker compose exec app php artisan migrate:fresh --seed

audit:
	docker compose exec app composer audit

check-versions:
	@docker compose exec -T app php -r 'echo "PHP ", PHP_VERSION, PHP_EOL; exit(version_compare(PHP_VERSION,"8.5.12",">=")?0:1);'
	@docker compose exec -T db sh -c 'mysql -uroot -p"$$MYSQL_ROOT_PASSWORD" -N -e "SELECT CONCAT(\"MySQL \", VERSION())" 2>/dev/null'
	@echo "Verifica que MySQL sea >= 9.7.4"
