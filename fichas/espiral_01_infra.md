# Ficha de Sistematización — Espiral 1
## ERP Django · Espiral E1: Infraestructura y Configuración Base
## UTEC Celaya · Técnico en Programación (SEP 3061300006-23)

| Campo | Contenido |
|---|---|
| **Número de espiral** | 1 |
| **Nombre del ciclo** | Infraestructura y Configuración Base |
| **Semanas** | W01 – W03 |
| **Fecha de inicio** | 02/10/2026 |
| **Fecha de cierre** |10/10/2026 |
| **Responsable** | [Kimberly Fernanda Belman Martinez] |
| **Asesor** | MC. Román Fernando López González |

---

## 1. Objetivo del ciclo

Establecer el entorno de desarrollo portable en USB y desplegar el
proyecto Django base en Render.com, de modo que cualquier avance
posterior tenga una URL pública verificable desde el inicio del proyecto.

---

## 2. Tareas realizadas

| # | Tarea | Estado | Tiempo invertido |
|---|---|---|---|
| 1 | Configurar Python 3.11 embeddable en USB | ✅ | h:mm |
| 2 | Instalar pip y virtualenv | ✅ | h:mm |
| 3 | Configurar Git Portable | ✅ | h:mm |
| 4 | Crear scripts iniciar/finalizar sesión | ✅ | h:mm |
| 5 | Crear proyecto Django con 5 apps | ✅ | h:mm |
| 6 | Sistema de templates Fable 5 AzulERP | ✅ | h:mm |
| 7 | Configurar WhiteNoise y estáticos | ✅ | h:mm |
| 8 | Completar settings_prod.py con PostgreSQL | ✅ | h:mm |
| 9 | Crear Procfile, Dockerfile, docker-compose.yml | ✅ | h:mm |
| 10 | Crear render.yaml | ✅ | h:mm |
| 11 | Desplegar en Render.com → URL pública | ✅ | h:mm |
| 12 | Ejecutar Sprint 0 Review y Retrospectiva | ✅ | h:mm |

---

## 3. Evidencias generadas

- [ ] Repositorio GitHub: `https://github.com/tu-usuario/erp-django-utec`
- [ ] URL pública Render: `https://erp-django-utec.onrender.com`
- [ ] Captura de pantalla: `evidencias/espiral_01/render_url.png`
- [ ] Captura de pantalla: `evidencias/espiral_01/manage_check.png`
- [ ] Resultado de tests: `Ran 33 tests in X.XXXs — OK`
- [ ] Commit de cierre:
2d0c03b (HEAD -> main, tag: sprint-0-cierrevvv, tag: sprint-0-cierre) Sprint 0 W02 CIERRE: MVT completo + Fable5 + WhiteNoise + 23 tests OK
10e94ab Sprint 0 W02: render() + templates Fable5 AzulERP x6 vistas
f97c6e9 Sprint 0 W01: suite de tests de entorno (11 tests OK)
2256442 Sprint 0 W01: entorno portable + proyecto Django base + 5 apps


---

## 4. Criterios de aceptación verificados

| Criterio | ¿Cumplido? | Evidencia |
|---|---|---|
| `manage.py check --deploy` sin warnings críticos | ✅ / ❌ | Captura de terminal |
| URL pública `https://…onrender.com/` → HTTP 200 | ✅ / ❌ | Captura del navegador |
| Repositorio con ≥ 6 commits en rama `main` | ✅ / ❌ | `git log --oneline` |
| 33 tests pasando (W01 + W02 + W03) | ✅ / ❌ | Resultado pytest |
| Ficha Schmelkes E1 completa | ✅ / ❌ | Este documento |

---

## 5. Problemas encontrados y soluciones

| Problema | Causa | Solución aplicada |
|---|---|---|
| `ModuleNotFoundError: No module named 'django'` al ejecutar `manage.py` | El entorno virtual `env_erp` estaba activo, pero Django no estaba instalado en él | Se ejecutó `python -m pip install -r requirements.txt` dentro del entorno activado |
| 14 tests con error `AttributeError: 'super' object has no attribute 'dicts'` | Django 4.2 no es compatible con Python 3.14. Falla al copiar el `Context` de las plantillas en el cliente de pruebas | Se actualizó Django a 5.2.8 o superior (`pip install --upgrade "Django>=5.2.8,<5.3"`) |
| `test_django_version_4_2` fallaba con `AssertionError: 4 != 5` | La prueba esperaba Django 5, pero estaba instalado Django 4.x | Con la actualización a Django 5.2 la prueba pasó. También se actualizó `requirements.txt` |

---

## 6. Lecciones aprendidas

1. Siempre hay que verificar que el entorno virtual esté activado y que las dependencias estén instaladas (`pip list`) antes de correr el proyecto.
2. La versión de Python y la de Django deben ser compatibles. Hay que revisar la tabla de compatibilidad antes de elegir versiones, sobre todo con Python recién lanzado como la 3.14.
3. `requirements.txt` debe fijar versiones que coincidan con las que se probaron, para que el despliegue en Render use el mismo entorno que el local.

---

## 7. Tiempo total invertido

| Categoría | Horas |
|---|---|
| Diseño / planeación | |
| Implementación | |
| Pruebas | |
| Despliegue | |
| Documentación | |
| **Total Espiral 1** | |

---

## 8. Conexión con el trabajo recepcional

> Esta espiral aporta evidencia para el **Capítulo 4** (Desarrollo),
> sección 4.1 "Espiral 1: Infraestructura", y para el
> **Capítulo 3** (Metodología), subsección "Ciclos del modelo espiral".