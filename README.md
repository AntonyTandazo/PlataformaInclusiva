# Conecta

Plataforma de cursos de comunicación inclusiva (Braille, lengua de señas y comunicación inclusiva).

> Proyecto académico — Materia: Construcción de Software · Equipo: 8 integrantes · Plazo: 4 meses (16 semanas)

---

## 1. Requisitos previos

Cada integrante debe tener instalado en su propia máquina:

- **Docker Desktop** (con Docker Compose v2) — [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/)
- **WSL 2** (recomendado en Windows) o Docker Engine nativo
- **Git**

> No hace falta instalar PHP, MySQL ni Composer en la máquina host. Todo corre dentro de los contenedores.

---

## 2. Levantar el proyecto (3 pasos)

### Paso 1 — Clonar el repositorio

```bash
git clone https://github.com/TU-USUARIO/conecta.git
cd conecta
```

### Paso 2 — Configurar las variables de entorno

Copiar el archivo de ejemplo y editar las contraseñas:

```bash
cp .env.example .env
```

Abrí `.env` con cualquier editor de texto y cambiá al menos las contraseñas:

```env
DB_DATABASE=DBConstLeng
DB_USERNAME=conecta
DB_PASSWORD=Construccion7u7
DB_ROOT_PASSWORD=Construccion7u7
```

> ⚠️ **`.env` nunca se sube a Git.** Está en `.gitignore`. Cada integrante usa su propia copia con sus contraseñas.

### Paso 3 — Construir y levantar los contenedores

```bash
docker compose build --pull
docker compose up -d
```

Esto levanta los siguientes servicios:

| Servicio | Puerto | ¿Qué hace? |
|---|---|---|
| `nginx` | 8080 | Servidor web, recibe las peticiones HTTP |
| `app` | 9000 (interno) | Laravel + PHP-FPM |
| `queue` | — | Procesa trabajos en segundo plano (insignias, correos) |
| `scheduler` | — | Tareas programadas (ranking semanal, rachas) |
| `db` | 3306 (solo localhost) | MySQL 9.7 |
| `mailpit` | 8025 | Bandeja de correo falso para desarrollo |

Cuando termine, podés entrar a:

- **Aplicación:** http://localhost:8080
- **Mailpit (correos de prueba):** http://localhost:8025

---

## 3. Comandos útiles

Todos los comandos de PHP, Composer y Artisan se ejecutan **dentro del contenedor `app`**:

| Comando | Qué hace |
|---|---|
| `docker compose up -d` | Levanta todos los servicios en segundo plano |
| `docker compose down` | Detiene y elimina los contenedores |
| `docker compose logs -f` | Ve los logs en tiempo real |
| `docker compose exec app bash` | Abre una terminal dentro del contenedor `app` |
| `docker compose exec app php artisan migrate` | Ejecuta las migraciones de base de datos |
| `docker compose exec app php artisan migrate:fresh --seed` | Reinicia la BD y carga datos de ejemplo |
| `docker compose exec app php artisan test` | Ejecuta las pruebas automatizadas |
| `docker compose exec app composer audit` | Audita vulnerabilidades en dependencias de Composer |
| `docker compose exec -T app php -v` | Muestra la versión de PHP (debe ser >= 8.5.12) |

> Si no tenés `make` instalado en Windows, usá los comandos `docker compose` directamente. El `Makefile` está incluido para entornos con `make` (Linux/WSL2).

---

## 4. Organización de carpetas

```
conecta/
├── .github/
│   └── workflows/
│       └── ci.yml              # Pipeline de CI (Pint, PHPStan, composer audit, pruebas)
├── docker/
│   ├── nginx/
│   │   └── default.conf        # Configuración de Nginx (puerto 80, PHP-FPM)
│   └── php/
│       ├── Dockerfile          # Imagen propia sobre php:8.5-fpm con extensiones necesarias
│       └── entrypoint.sh       # Arranque del contenedor: composer install, migraciones, seeders
├── src/                        # Aplicación Laravel 13 (se genera al hacer `docker compose up`)
│   ├── app/
│   │   └── Modules/            # Módulos de dominio (Identity, Learning, Braille, Sign, Gamification, Content)
│   ├── config/
│   ├── database/
│   │   ├── migrations/
│   │   ├── seeders/
│   │   └── factories/
│   ├── public/                 # Punto de entrada web (index.php)
│   ├── resources/
│   │   ├── views/              # Vistas Blade
│   │   └── lang/               # Archivos de idioma (textos en español)
│   ├── routes/
│   ├── tests/
│   └── ...
├── docs/
│   └── planning_plataforma_lenguaje_inclusivo.md   # Planning completo del proyecto
├── docker-compose.yml          # Orquestación de los 6 servicios
├── Makefile                    # Atajos (make up, down, test, audit, check-versions)
├── .env.example                # Plantilla de variables (sin secretos reales)
├── .env                        # Variables reales (NO se sube a Git)
├── .gitignore                  # Archivos ignorados por Git
├── AGENTS.md                   # Reglas para el agente de IA (OpenCode)
└── README.md                   # Este archivo
```

### Módulos de dominio (dentro de `src/app/Modules/`)

| Módulo | Contenido |
|---|---|
| `Identity/` | Registro, login, perfil, preferencias de accesibilidad, roles |
| `Learning/` | Cursos, unidades, lecciones, ejercicios, progreso, matrículas |
| `Braille/` | Celda Braille interactiva, tabla de caracteres, traductor |
| `Sign/` | Alfabeto dactilológico, vocabulario en video, ejercicios de reconocimiento |
| `Gamification/` | XP, niveles, rachas, ranking, insignias, mascota |
| `Content/` | Panel de administración de cursos, lecciones, medios, reportes de errores |

---

## 5. ¿Qué NO subir a Git?

El archivo `.gitignore` ya cubre lo principal, pero recordá nunca subir:

- `.env` — contiene contraseñas reales
- `vendor/` — dependencias de Composer (se instalan con `composer install`)
- `node_modules/` — si se usa Node en el futuro
- `storage/` y `bootstrap/cache/` — archivos generados por Laravel
- `.env` con claves de producción

---

## 6. Versiones mínimas obligatorias

| Tecnología | Versión mínima | ¿Dónde se verifica? |
|---|---|---|
| PHP | **8.5.12** (último parche 8.5.x) | Dockerfile + `php -v` |
| MySQL | **9.7 LTS** (>= 9.7.4) | `docker-compose.yml` + `mysql --version` |
| Laravel | **13.x** | `composer.json` |

> Antes de cada sprint, el equipo ejecuta `make check-versions` (o los comandos equivalente de Docker Compose) para confirmar que las versiones cumplen el mínimo de seguridad.

---

## 7. Reglas del equipo

1. **Nunca subir `.env` ni contraseñas a Git.**
2. Todo cambio en `docker/` o `docker-compose.yml` pasa por revisión del equipo porque afecta a todos.
3. Los seeders deben ser idempotentes.
4. Commits pequeños con mensajes tipo *Conventional Commits* (`feat:`, `fix:`, `docs:`, etc.).
5. No agregar dependencias de Composer ni npm sin aprobación del equipo.
6. Cada funcionalidad crítica lleva pruebas. Ejecutar `php artisan test` antes de dar una tarea por terminada.

---

## 8. Siguiente paso tras levantar el entorno

Con el entorno funcionando, se continúa con la **Fase 1** del planning: Identidad (registro, login, verificación de correo, roles, perfil con preferencias de accesibilidad).

Revisá `docs/planning_plataforma_lenguaje_inclusivo.md` para ver todas las fases (Fase 0 a Fase 5) y el reparto de responsabilidades del equipo.
