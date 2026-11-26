# Guía para Agentes — Proyecto Conecta

Este documento es de lectura obligatoria para cualquier agente de IA (Claude Code, Anthropic Code, Anti-Gravity, OpenCode, u otro) que vaya a trabajar sobre este repositorio. Su propósito es que el agente entienda rápidamente qué se está construyendo, con qué tecnología, qué ya existe y qué reglas debe respetar.

---

## 0. Validación previa obligatoria (ANTES de empezar a trabajar)

**Ningún agente debe tocar código, ni proponer cambios, ni escribir archivos sin antes validar que el entorno esté correctamente instalado.** Este es un paso obligatorio para todos.

### Paso 0.1 — Verificar que el repositorio tiene todo

Antes de hacer cualquier cosa, confirmar que existen estos archivos en la raíz del repositorio:

| Archivo | ¿Qué es? |
|---|---|
| `docker-compose.yml` | Orquestación de los 6 servicios |
| `docker/php/Dockerfile` | Imagen de PHP 8.5.12 |
| `docker/php/entrypoint.sh` | Arranque automático de Laravel |
| `docker/nginx/default.conf` | Configuración de Nginx |
| `.env.example` | Plantilla de variables de entorno |
| `src/artisan` | Laravel instalado dentro de `src/` |
| `src/composer.json` | Dependencias de PHP |
| `AGENT_GUIDE.md` | Esta guía |
| `INTEGRANTES_RESPONSABILIDADES.md` | Quién hace qué en el equipo |
| `docs/planning_plataforma_lenguaje_inclusivo.md` | Planning oficial (fuente de verdad) |

Si falta alguno de estos archivos, **detenerse y reportarlo al usuario inmediatamente**. No continuar.

### Paso 0.2 — Verificar que Docker está disponible

Ejecutar (o pedir al usuario que ejecute):

```powershell
docker --version
docker compose version
```

Si Docker no está instalado o no responde, **detenerse y reportarlo al usuario**. El proyecto no puede funcionar sin Docker Desktop.

### Paso 0.3 — Verificar que los contenedores levantan

```powershell
docker compose build --pull
docker compose up -d
```

Luego verificar que todos los servicios estén arriba:

```powershell
docker compose ps
```

Todos deben mostrar `Up` o `Healthy`. Si algún servicio está `Exited`, `Restarting` o `Error`, **detenerse y reportar cuál falla y el mensaje de error**.

### Paso 0.4 — Verificar PHP y MySQL dentro de los contenedores

```powershell
docker compose exec -T app php -v
```

Debe mostrar `PHP 8.5.12` o superior. Si muestra una versión menor, reportarlo.

```powershell
docker compose exec -T db mysqladmin ping -uroot -p"Construccion7u7" --silent
```

Debe responder `mysqld is alive`. Si falla, reportar el error.

### Paso 0.5 — Verificar que Laravel responde

Abrir en el navegador: `http://localhost:8080`

Debe mostrar la página de bienvenida de Laravel. Si no carga, reportar el error.

### Paso 0.6 — Si algo falta o falla

El agente debe escribir al usuario algo como:

> **Validación previa fallida:** Falta[X] / El servicio[Y] no levanta / PHP versión[Z] no cumple el mínimo. Detalles: [mensaje de error exacto]. No se puede continuar hasta que se resuelva.

**Solo después de que todo esté verde, el agente puede comenzar a trabajar.**

---

## 1. Concepto del proyecto

**Nombre:** Conecta (provisional)  
**Tipo:** Plataforma web de cursos interactivos de comunicación inclusiva  
**Materia:** Construcción de Software  
**Equipo:** 8 integrantes  
**Plazo:** 4 meses (16 semanas), divididos en dos parciales (50% cada uno)

### Qué resuelve

Aprender Braille o lengua de señas suele requerir cursos presenciales costosos o poco accesibles. Los recursos gratuitos están dispersos, no tienen seguimiento del progreso ni motivación para continuar. Conecta ofrece lecciones cortas, práctica inmediata y gamificación sana (puntos, rachas, ranking, insignias y mascota virtual), de forma gratuita o de muy bajo costo.

### Público objetivo

Personas que quieren comunicarse mejor con personas ciegas, sordas o con otras discapacidades: familiares, docentes, compañeros, personal de salud o atención al cliente, y también personas ciegas o sordas que quieran aprender.

---

## 2. Alcance actual (50% — Primer parcial)

Este repositorio corresponde al **50% del proyecto** (primer parcial). El otro 50% se completa en el segundo parcial.

**Lo que se entrega en este parcial:** un avance funcional del proyecto grupal, con el entorno listo, la base de datos operativa y los módulos principales funcionando.

---

## 3. Stack tecnológico

| Tecnología | Versión | Notas |
|---|---|---|
| PHP | **8.5.12+** | Último parche 8.5.x. Crítico por vulnerabilidades CVE-2026-109618 y CVE-2026-109619 |
| MySQL | **9.7 LTS** (>= 9.7.4) | Rama LTS, parches trimestrales de seguridad |
| Laravel | **13.x** | Full-stack con Blade (no React ni Vue) |
| Composer | **2.x** (>= 2.9.8) | Versiones fijas en `composer.lock` |
| Bootstrap | **5.3.8** | Estilos y componentes, archivos compilados en `public/vendor/` |
| JavaScript | ES modules nativo | Sin Node en el proyecto |
| Nginx | Imagen oficial `nginx:stable` | Servidor web, puerto 8080 |
| Docker Compose | v2 | Todo el equipo levanta con un solo comando |
| Mailpit | Última | Bandeja de correo falso en puerto 8025 |

**No usar:** Redis, Node.js como dependencia del proyecto, Docker-in-Docker (DinD).

---

## 4. Arquitectura

Monolito modular en capas, una sola aplicación Laravel organizada por módulos de dominio.

```
app/
└── Modules/
    ├── Identity/       (Registro, login, perfil, preferencias de accesibilidad, roles)
    ├── Learning/       (Cursos, unidades, lecciones, ejercicios, progreso, matrículas)
    ├── Braille/        (Celda Braille interactiva, tabla de caracteres, traductor)
    ├── Sign/           (Alfabeto dactilológico, vocabulario en video, ejercicios de reconocimiento)
    ├── Gamification/   (XP, niveles, rachas, ranking, insignias, mascota)
    └── Content/        (Panel de administración de cursos, lecciones, medios)
```

### Patrones de diseño

- **MVC:** toda la app
- **Action/Service:** lógica de negocio fuera de controladores
- **Strategy:** evaluadores de ejercicios (uno por tipo)
- **Observer/Eventos:** `LessonCompleted` → XP, racha, insignias, mascota
- **State:** etapas de la mascota
- **Policy:** permisos por rol
- **Factory/Seeder:** cursos de ejemplo y usuarios de prueba

### Decisión de gamificación por eventos

La gamificación no se mezcla con el código de las lecciones. Cuando un estudiante completa una lección se dispara `LessonCompleted`, y los módulos interesados reaccionan de forma independiente.

---

## 5. Estado actual del repositorio (Fase 0 completa)

### Qué ya existe y funciona

- Entorno Docker Compose con 6 servicios: `nginx`, `app`, `queue`, `scheduler`, `db`, `mailpit`
- Proyecto **Laravel 13** generado dentro de `src/`
- PHP 8.5.12 instalado y verificable
- MySQL 9.7 en ejecución con base de datos `DBConstLeng`
- Migraciones de Laravel ejecutadas (`users`, `migrations`, `sessions`, `jobs`, `cache`, etc.)
- `APP_KEY` generada
- `.env` configurado con credenciales de base de datos
- CI en GitHub Actions (Pint, PHPStan/Larastan, `composer audit`, pruebas)
- `AGENTS.md` con reglas para agentes OpenCode
- `README.md` con instrucciones de arranque

### Comandos clave

```powershell
docker compose build --pull
docker compose up -d
docker compose exec app bash
docker compose exec app php artisan migrate
docker compose exec app php artisan test
docker compose exec app composer audit
```

### URLs una vez levantado

- Aplicación: `http://localhost:8080`
- Mailpit: `http://localhost:8025`

---

## 6. Guía de instalación para agentes

Todo agente que se sume al proyecto debe seguir estos pasos para instalar y verificar el entorno:

### Instalación paso a paso

1. **Clonar el repositorio**
   ```powershell
   git clone -b develop https://github.com/TU-USUARIO/conecta.git
   cd conecta
   ```

2. **Configurar variables de entorno**
   ```powershell
   cp .env.example .env
   ```
   Editar `.env` y cambiar las contraseñas si es necesario. **`.env` nunca se sube a Git.**

3. **Levantar Docker**
   ```powershell
   docker compose build --pull
   docker compose up -d
   ```

4. **Ejecutar validación previa** (sección 0 de este documento)

5. **Si todo está verde, comenzar a trabajar** en las tareas asignadas.

### Comandos útiles para agentes

| Comando | Qué hace |
|---|---|
| `docker compose ps` | Ver estado de todos los contenedores |
| `docker compose logs -f` | Ver logs en tiempo real |
| `docker compose exec app bash` | Entrar al contenedor de Laravel |
| `docker compose exec app php artisan migrate` | Ejecutar migraciones de BD |
| `docker compose exec app php artisan test` | Ejecutar pruebas |
| `docker compose exec app composer audit` | Auditar vulnerabilidades |
| `docker compose down` | Detener todos los servicios |

---

## 7. Reglas obligatorias para cualquier agente

1. **Leer `docs/planning_plataforma_lenguaje_inclusivo.md` como fuente de verdad.** Si algo contradice, preguntar antes de actuar.
2. **Validación previa obligatoria:** verificar que el entorno esté instalado y funcionando antes de tocar cualquier código (sección 0).
3. **Trabajar por fases.** Detenerse al terminar cada fase. No avanzar sin completar la actual.
4. **Versiones mínimas:** PHP >= 8.5.12, MySQL >= 9.7.4, Laravel 13.x. Nunca bajar versiones.
5. **No agregar dependencias** (Composer ni npm) sin aprobación del equipo.
6. **Todo comando PHP/Composer/Artisan/MySQL** se ejecuta con `docker compose exec`.
7. **Nunca subir `.env` ni contraseñas.** Usar `.env.example`.
8. **Código y commits en inglés; textos de interfaz en español** (archivos de idioma de Laravel).
9. **Lógica de negocio en Actions/Services**, no en controladores ni vistas.
10. **Todo contenido visual lleva texto alternativo**; todo componente interactivo es usable con teclado y lector de pantalla (WCAG 2.2 AA).
11. **Cada funcionalidad crítica lleva pruebas.** Ejecutar `php artisan test` y Pint antes de dar una tarea por terminada.
12. **Los seeders son idempotentes.**
13. **Commits pequeños** tipo Conventional Commits (`feat:`, `fix:`, `docs:`, etc.). Nunca agregar "Co-Authored-By" ni atribución de IA.
14. **Nunca afirmar que algo funciona sin haberlo ejecutado.** Reportar la salida real.
15. **Accesibilidad primero:** la plataforma enseña comunicación inclusiva, debe ser un ejemplo de accesibilidad.

---

## 8. Documentación requerida (según el programa de la asignatura)

- Documento de diseño detallado (plantilla correspondiente)
- Diagramas de clases
- Diagramas de secuencia y otros diagramas de comportamiento de los casos de uso
- Plan de pruebas
- Manual de soporte
- Manual de usuario
- Artículos o documentos de conclusiones y experiencias aprendidas
- Código fuente y script de MySQL

---

## 9. Cómo proceder con un nuevo agente

1. El agente lee este `AGENT_GUIDE.md`.
2. El agente lee `docs/planning_plataforma_lenguaje_inclusivo.md`.
3. El agente ejecuta la **validación previa obligatoria** (sección 0).
4. El usuario asigna al agente un integrante del equipo (ver `INTEGRANTES_RESPONSABILIDADES.md`).
5. El agente trabaja solo en las tareas asignadas a ese integrante, dentro del alcance del 50% (primer parcial).

---

## 10. Archivos del repositorio (estructura actual)

```
conecta/
├── .github/workflows/ci.yml
├── docker/
│   ├── nginx/default.conf
│   └── php/Dockerfile + entrypoint.sh
├── docs/
│   └── planning_plataforma_lenguaje_inclusivo.md
├── src/                    # Laravel 13 (aplicación)
├── AGENT_GUIDE.md          # ← este archivo
├── AGENTS.md               # reglas para OpenCode
├── INTEGRANTES_RESPONSABILIDADES.md  # ← nombres y tareas del equipo
├── docker-compose.yml
├── Makefile
├── .env.example
├── .gitignore
└── README.md
```
