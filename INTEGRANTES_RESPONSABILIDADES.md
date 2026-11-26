# Integrantes y Responsabilidades — Proyecto Conecta

Este documento asigna a cada integrante del equipo qué debe hacer dentro del **50% del alcance (primer parcial)**.

El alcance del primer parcial corresponde a un avance funcional del proyecto grupal: entorno listo, base de datos operativa, y los módulos principales funcionando (basado en el `planning_plataforma_lenguaje_inclusivo.md`, secciones 12.3 y 12.4).

---

## Tabla de integrantes y responsabilidades

| # | Integrante | Responsabilidad principal | Alcance del 50% (primer parcial) |
|---|---|---|---|
| 1 | **ANTONY JAVIER TANDAZO TORRES** | Infraestructura, seguridad y calidad | Docker Compose, CI/CD (GitHub Actions), versiones seguras (PHP 8.5.12, MySQL 9.7.4), `composer audit`, Pint, PHPStan, pruebas, `.gitignore`, `.env.example`, seguridad OWASP básica, validación de entorno para nuevos agentes |
| 2 | **MAIK ARIEL BERMEO BARROS** | Identidad y accesibilidad | Registro, login, cierre de sesión, verificación de correo (Mailpit), roles (`learner`, `editor`, `admin`) con Policies, perfil con apodo, preferencias de accesibilidad (alto contraste, tamaño de letra, reducir movimiento), auditoría de accesibilidad WCAG 2.2 AA |
| 3 | **ANDRES ARTURO DUEÑAS PLUA** | Cursos y contenido (admin) | Migraciones y modelos (`courses`, `units`, `lessons`, `lesson_contents`, `exercises`, `media_assets`), catálogo público de cursos, panel de administración para crear/editar cursos y lecciones, subida segura de medios, seeder idempotente con un curso de ejemplo |
| 4 | **BENJAMIN GUSTAVO ESPINOZA RUIZ** | Motor de ejercicios y Braille | Motor de evaluación con patrón Strategy (`choice`, `match`, `braille_read`, `braille_write`, `sign_to_word`), pantalla de lección con retroalimentación inmediata, registro de progreso e intentos, componente de celda Braille interactiva y traductor con pruebas unitarias |
| 5 | **PETER MATEO PINELA GONZALEZ** | Gamificación | Evento `LessonCompleted` y listeners (XP, racha, insignias, mascota), `xp_events` + `user_stats`, niveles y rachas, ranking semanal con `leaderboard_snapshots`, insignias y pantalla de logros |
| 6 | **GREDY JEANPIERRE PIONCE PINARGOTE** | Frontend, UX y contenido de señas | Diseño móvil primero con Bootstrap 5.3.8, layout accesible, reproductor de señas (video nativo, descripción textual), mascota accesible (SVG/etapas), preferencias de accesibilidad en UI, prototypes de pantallas |
| 7 | **RICHARD GABRIEL AYALA NAVARRETE** | Documentación, diagramas y plan de pruebas | Documento de diseño detallado, diagramas de clases, diagramas de secuencia y comportamiento de casos de uso, plan de pruebas, coordinación de documentación del grupo |
| 8 | **ADRIAN SALOMON VILLALBA SECAIRA** | Manuales y entrega final del parcial | Manual de usuario (cómo se le indicará al usuario de cómo funciona la plataforma), manual de soporte (paso a paso para levantar el sistema desde GitHub), artículos/documentos de conclusiones y experiencias aprendidas, script de MySQL, revisión final del entregable del primer parcial |

---

## Flujo de trabajo con ramas personales (obligatorio)

Cada integrante debe seguir este flujo para trabajar sobre el repositorio:

### 1. Crear su rama personal

Cada integrante crea una rama personal usando su **primer nombre y primer apellido**, en minúsculas, sin tildes, separados por guion.

Ejemplo para Antony Javier Tandazo Torres:

```powershell
git checkout -b antony-tandazo
```

Ejemplo para Maik Ariel Bermeo Barros:

```powershell
git checkout -b maik-bermeo
```

### 2. Trabajar en la rama personal

Todo el desarrollo del integrante se hace en su rama personal. Nunca trabajar directamente sobre `develop` ni `main`.

### 3. Antes de volver a trabajar (sincronizar con develop)

Cada vez que el integrante vuelva a trabajar en el proyecto (por ejemplo, un día diferente), debe verificar si hay actualizaciones en `develop` y integrarlas a su rama personal antes de seguir codificando:

```powershell
git checkout antony-tandazo
git fetch origin develop
git merge origin develop
```

Si hay conflictos, resolverlos antes de continuar.

### 4. Cuando termine su parte

Cuando el integrante termine una tarea y todos los cambios estén probados localmente:

1. Commit en su rama personal:

   ```powershell
   git add .
   git commit -m "feat: descripción del cambio"
   ```

2. Subir su rama personal al repositorio:

   ```powershell
   git push origin antony-tandazo
   ```

3. Abrir un **Pull Request (PR)** de su rama personal hacia `develop` (no a `main`).

### 5. Revisión y aprobación

Después de abrir el PR a `develop`:

- El usuario/líder del grupo **verifica, aprueba y prueba los cambios**.
- Si todo está bien, se hace el merge a `develop`.
- Si algo falla, el integrante corrige en su rama personal y actualiza el PR.

**Nunca hacer push directo a `main`.** `main` solo se actualiza con entregas oficiales del parcial.

---

## Cómo usar este documento

1. Cada integrante lee su fila en la tabla.
2. Cada integrante revisa `docs/planning_plataforma_lenguaje_inclusivo.md` para entender el detalle técnico de su responsabilidad.
3. Cada integrante crea su rama personal (`primer-nombre-primer-apellido`) y trabaja en ella.
4. Cada vez que vuelva a trabajar, sincronizar su rama personal con `develop`.
5. Cuando termine, abrir PR de su rama personal a `develop`. El usuario verifica, aprueba y prueba.
6. El integrante 7 (Richard) coordina los diagramas y el documento de diseño.
7. El integrante 8 (Adrian) revisa que el manual de soporte funcione en un entorno distinto al de desarrollo (prueba de otro equipo).

---

## Diagramas sugeridos (para el área de documentación)

El integrante 7 (Richard) debe entregar al menos estos 3 diagramas como parte del documento de diseño detallado:

| # | Diagrama | Qué debe mostrar | Herramienta sugerida |
|---|---|---|---|
| 1 | **Diagrama de clases del dominio** | Entidades principales del sistema: Usuario, Curso, Unidad, Lección, Ejercicio, Progreso, Insignia, XP, Mascota, con sus atributos y relaciones. | [archify.si](https://archify.si/), Draw.io, Lucidchart, Mermaid, o plantilla UML de la asignatura |
| 2 | **Diagrama de secuencia — Completar una lección** | Flujo desde que el estudiante abre una lección, responde ejercicios, se guarda el progreso, se dispara el evento de gamificación y se actualizan XP/racha/insignias. | [archify.si](https://archify.si/), Draw.io, Lucidchart, Mermaid, o plantilla UML de la asignatura |
| 3 | **Diagrama de casos de uso** | Actores (Estudiante, Administrador, Editor) y sus casos de uso: registrarse, iniciar sesión, inscribirse en curso, hacer lección, administrar contenido, revisar reporte de error. | [archify.si](https://archify.si/), Draw.io, Lucidchart, Mermaid, o plantilla UML de la asignatura |

Estos diagramas se documentan en el `docs/planning_plataforma_lenguaje_inclusivo.md` o en un documento de diseño separado, siguiendo la plantilla de la asignatura.

**Importante para el agente que ayude a crear los diagramas:** antes de dibujar cualquier diagrama, el agente debe leer obligatoriamente `AGENT_GUIDE.md` y `docs/planning_plataforma_lenguaje_inclusivo.md` para tener el contexto completo de cómo funciona el sistema, qué módulos existen, cuál es el flujo de gamificación, y cuáles son las reglas de negocio. No crear diagramas sin ese contexto.

---

## Entregables del primer parcial (50%)

Según el programa de la asignatura, el primer parcial requiere:

- [ ] Avance del proyecto grupal presentado
- [ ] Entorno Docker funcionando para todos los integrantes
- [ ] Código fuente en el repositorio
- [ ] Base de datos operativa
- [ ] Documentación requerida (ver `AGENT_GUIDE.md`, sección 7)

---

## Notas importantes

- El docente advirtió que **no completar el proyecto puede impedir aprobar la asignatura** en el periodo ordinario.
- Existen **tareas individuales y actividades de evaluación** además del proyecto grupal.
- Un grupo probará el **manual de soporte de otro equipo**. Si no consigue levantar el sistema siguiendo las instrucciones, el manual deberá corregirse.
- Se deben reutilizar las plantillas establecidas en asignaturas anteriores cuando corresponda.
