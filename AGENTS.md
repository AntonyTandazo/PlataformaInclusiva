# Reglas para OpenCode (agente)

Siga `docs/planning_plataforma_lenguaje_inclusivo.md` como fuente de verdad. Si algo contradice, pregunte antes de actuar.

## Trabajo por fases
Trabaje por fases del planning y deténgase al terminar cada una. No avance a la siguiente sin completar la actual.

## Versiones mínimas (no bajar)
- PHP >= 8.5.12
- MySQL >= 9.7.4
- Laravel 13.x

## Dependencias
No agregue dependencias (Composer ni npm) sin aprobación del equipo. Preferir lo que ya trae Laravel.

## Ejecución
Todo comando de PHP, Composer, Artisan o MySQL se ejecuta con `docker compose exec`.

## Seguridad
Nunca suba `.env`, claves ni contraseñas. Use `.env.example`.

## Código y textos
- Código, tablas y commits en inglés.
- Textos de interfaz en español (archivos de idioma de Laravel).

## Arquitectura
- Lógica de negocio en Actions/Services, no en controladores ni vistas.
- Todo contenido visual lleva texto alternativo; todo componente interactivo es usable con teclado y lector de pantalla.
- Cada funcionalidad crítica lleva pruebas. Ejecute `php artisan test` y Pint antes de dar una tarea por terminada.
- Los seeders son idempotentes.

## Commits
Commits pequeños con mensajes tipo Conventional Commits. Nunca agregue "Co-Authored-By" ni atribución de IA.

## Verificación
Nunca afirme que algo funciona sin haberlo ejecutado; reporte la salida real.
