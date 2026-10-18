# Sprint 0 Retrospective — ERP Django
## Semanas W01-W03 · Espiral 1

**Fecha:** 15/10/2026
**Facilitador/Scrum Master:** [Belman Martinez Kimberly Fernanda]

## ¿Qué funcionó bien? (Keep)
1. Los tests automatizados (30 en total) detectaron a tiempo el fallo de staticfiles en el login del admin, antes de llegar a producción.
2. Documentar los pasos en el README y en las guías hizo que el entorno se pudiera reproducir desde cero en otra carpeta.
3. Hacer commits pequeños y frecuentes dejó el trabajo respaldado localmente aunque falló la conexión con GitHub.

## ¿Qué mejorar? (Improve)
1. Verificar que el entorno virtual tenga las dependencias instaladas (`pip install -r requirements.txt`) antes de correr los tests; se perdió tiempo con el error `No module named 'django'`.
2. Separar la configuración de desarrollo, tests y producción en `settings.py`, por ejemplo el almacenamiento de estáticos con WhiteNoise.

## ¿Qué eliminar? (Drop)
1. Hacer `git add .` y commit sin revisar antes `git status` y `git log --stat`; así un commit solo incluyó el `.gitignore` y no se notó a tiempo.

## Acción de mejora (Kaizen) para Sprint 1
> Una sola acción concreta y medible:
> "En el Sprint 1, voy a correr `python manage.py test tests` y revisar `git status` antes de cada commit para mejorar la calidad de lo que subo al repositorio y evitar errores de configuración que se descubren tarde."

## Velocidad del Sprint 0

| HU | Planificado (pts) | Entregado (pts) |
|---|---|---|
| HU-E1-01 Entorno portable | 3 | 3 |
| HU-E1-02 Scripts sincronización | 2 | 2 |
| HU-E1-03 Repositorio GitHub | 2 | 2 |
| HU-E1-04 Despliegue Render.com | 3 | 3 |
| **Total** | **10** | **10** |

**Velocidad real del equipo:** 10 puntos / sprint