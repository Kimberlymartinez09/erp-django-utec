# Ficha de Sistematización — Espiral 1
## ERP Django · Espiral E1: Infraestructura y Configuración Base
## UTEC Celaya · Técnico en Programación (SEP 3061300006-23)

| Campo | Contenido |
|---|---|
| **Número de espiral** | 1 |
| **Nombre del ciclo** | Infraestructura y Configuración Base |
| **Semanas** | W01 – W03 |
| **Fecha de inicio** | 02/10/2026 |
| **Fecha de cierre** | ___/___/_____ |
| **Responsable** | Kimberly Fernanda Belman Martinez |
| **Asesor** | MC. Román Fernando López González |

---

## 1. Objetivo del ciclo

Establecer el entorno de desarrollo portable en USB y desplegar el
proyecto Django base en Render.com, de modo que cualquier avance
posterior tenga una URL pública verificable desde el inicio del proyecto.

---

## 2. Tareas realizadas

> Cambiar ⏳ por ✅ solo cuando la tarea esté realmente terminada.

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
| 11 | Desplegar en Render.com → URL pública | ⏳ | h:mm |
| 12 | Ejecutar Sprint 0 Review y Retrospectiva | ⏳ | h:mm |

---

## 3. Evidencias generadas

- [x] Repositorio GitHub: `https://github.com/Kimberlymartinez09/erp-django-utec`
- [ ] URL pública Render: `https://__________.onrender.com`
- [ ] Captura de pantalla: `evidencias/espiral_01/render_url.png`
- [ ] Captura de pantalla: `evidencias/espiral_01/manage_check.png`
- [ ] Resultado de tests: `Ran __ tests in X.XXXs — OK`
- [ ] Commit de cierre (pegar el resultado DESPUÉS de hacer el commit final):

```
(pegar aquí el resultado de: git log --oneline -5)
```

---

## 4. Criterios de aceptación verificados

| Criterio | ¿Cumplido? | Evidencia |
|---|---|---|
| `manage.py check --deploy` sin warnings críticos | ⏳ | Captura de terminal |
| URL pública `https://…onrender.com/` → HTTP 200 | ⏳ | Captura del navegador |
| Repositorio con ≥ 6 commits en rama `main` | ✅ | `git log --oneline` |
| Suite de tests completa pasando (W01 + W02 + W03) | ⏳ | Resultado de `python manage.py test tests --verbosity=0` |
| Ficha Schmelkes E1 completa | ⏳ | Este documento |

---

## 5. Problemas encontrados y soluciones

| Problema | Causa | Solución aplicada |
|---|---|---|
| `ModuleNotFoundError: No module named 'django'` al ejecutar `manage.py` | El entorno virtual `env_erp` estaba activo, pero Django no estaba instalado en él | Se ejecutó `python -m pip install -r requirements.txt` dentro del entorno activado |
| 14 tests con error `AttributeError: 'super' object has no attribute 'dicts'` | Django 4.2 no es compatible con Python 3.14. Falla al copiar el `Context` de las plantillas en el cliente de pruebas | Se actualizó Django a 5.2.8 o superior (`pip install --upgrade "Django>=5.2.8,<5.3"`) |
| `test_django_version_4_2` fallaba con `AssertionError: 4 != 5` | La prueba esperaba Django 5, pero estaba instalado Django 4.x | Con la actualización a Django 5.2 la prueba pasó. También se actualizó `requirements.txt` |
| Aviso `Could not find platform dependent libraries <exec_prefix>` al ejecutar Python del entorno virtual | El `env_erp` se había copiado o movido y apuntaba a una instalación de Python con una ruta que ya no existía | Se borró `env_erp` y `iniciar_sesion.bat` lo recreó en la PC; el aviso dejó de aparecer |
| El historial de Git del PC y el de la USB no coincidían (`not a git repository` y luego un repo de prueba sin relación con el real) | Se hizo `git init` en la carpeta de trabajo sin restaurar el historial real de la USB | Se borró el `.git` de prueba y `iniciar_sesion.bat` restauró el historial real desde la USB |
| `git push` rechazado con `non-fast-forward` | El historial local y el de GitHub contenían los mismos commits con identificadores distintos, sin ancestro común | Se unieron con `git merge -s ours --allow-unrelated-histories origin/main` y se subió sin `--force` |
| `git push` rechazado con error 403 | Windows tenía guardada la credencial de otra cuenta de GitHub | Se eliminó la credencial guardada y se fijó el usuario correcto en la URL del remoto |
| `origin` apuntaba a `TU_USUARIO/TU_REPO` | El marcador de ejemplo nunca se reemplazó por la URL real | `git remote set-url origin <URL real>` |
| `finalizar_sesion.bat` se detenía al reemplazar el `.git` de la USB | `ren` de CMD falló con la carpeta oculta `.git` | Se completó el reemplazo con `Rename-Item -Force` de PowerShell |
| El `.gitignore` de GitHub contenía marcadores `<<<<<<<` / `=======` / `>>>>>>>` | Se commiteó un conflicto de merge sin resolver | Se conservó la versión limpia local al unir los historiales |

---

## 6. Lecciones aprendidas

1. Siempre hay que verificar que el entorno virtual esté activado y que las dependencias estén instaladas (`pip list`) antes de correr el proyecto.
2. La versión de Python y la de Django deben ser compatibles. Hay que revisar la tabla de compatibilidad antes de elegir versiones, sobre todo con Python recién lanzado como la 3.14.
3. `requirements.txt` debe fijar versiones que coincidan con las que se probaron, para que el despliegue en Render use el mismo entorno que el local.
4. Un entorno virtual guarda rutas absolutas: no se copia entre carpetas o equipos, se recrea desde `requirements.txt`.
5. Ante un `push` rechazado hay que comparar los historiales (`git fetch` + `git log --graph --all`) antes de actuar, y nunca usar `--force`. Los respaldos (`.bundle`) y el repositorio en la USB permiten recuperar el trabajo ante cualquier error.

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