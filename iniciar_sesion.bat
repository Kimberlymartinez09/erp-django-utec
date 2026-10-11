@echo off
TITLE ERP Django - Iniciando Sesion
COLOR 0A

:: --- 1. RUTAS ---
SET USB_PATH=%~dp0
SET PC_WORK=C:\Temp_Workspace_ERP
SET BACKUP_DIR=C:\Temp_Workspace_ERP_respaldos
SET PATH=%USB_PATH%Python_Portable;%USB_PATH%Python_Portable\Scripts;%USB_PATH%Git_Portable\cmd;%USB_PATH%Git_Portable\ucrt64\bin;%PATH%

:: safe.directory solo para esta sesion (no toca el config global del PC)
SET GIT_CONFIG_COUNT=1
SET GIT_CONFIG_KEY_0=safe.directory
SET GIT_CONFIG_VALUE_0=*

echo ========================================================
echo  ERP DJANGO :: USB ^-^> PC
echo  USB: %USB_PATH%
echo  PC:  %PC_WORK%
echo ========================================================

if not exist "%PC_WORK%" (
    mkdir "%PC_WORK%"
    echo [OK] Carpeta creada: %PC_WORK%
)

:: --- 2. CODIGO USB -> PC (sin borrar nada; /XO no pisa archivos mas nuevos del PC) ---
echo Sincronizando codigo...
robocopy "%USB_PATH%." "%PC_WORK%" /E /XO /XD .git .git_tmp .git_old env_erp venv __pycache__ staticfiles Git_Portable Python_Portable WorkSpace_ERP "System Volume Information" /XF *.pyc iniciar_sesion.bat finalizar_sesion.bat >nul
if %errorlevel% GEQ 8 goto :fallo

:: --- 3. HISTORIAL (.git) ---
if not exist "%USB_PATH%.git" goto :git_ok

:: El PC no tiene repo -> restaurar desde la USB
if not exist "%PC_WORK%\.git" (
    echo Restaurando historial desde la USB...
    robocopy "%USB_PATH%.git" "%PC_WORK%\.git" /E >nul
    if errorlevel 8 goto :fallo
    goto :git_ok
)

cd /d "%PC_WORK%"
set USB_HEAD=
set PC_HEAD=
set DIRTY=
for /f %%h in ('git -C "%USB_PATH%." rev-parse HEAD 2^>nul') do set USB_HEAD=%%h
for /f %%h in ('git rev-parse HEAD 2^>nul') do set PC_HEAD=%%h

:: Aviso si hay cambios sin commit en el PC (solo informativo, no se toca nada)
for /f "delims=" %%h in ('git status --porcelain 2^>nul') do set DIRTY=1
if defined DIRTY echo [AVISO] Hay cambios sin commit en el PC. Haz commit antes de cerrar la sesion.

:: La USB no tiene commits -> nada que comparar, no tocar el PC
if not defined USB_HEAD (
    echo [AVISO] El repo de la USB no tiene commits. No se toca el historial del PC.
    goto :git_ok
)

:: Mismo punto -> todo igual
if "%USB_HEAD%"=="%PC_HEAD%" goto :git_ok

:: El PC no tiene commits -> la USB manda
if not defined PC_HEAD goto :actualizar_pc

:: La USB contiene todo lo del PC y mas -> actualizar el PC
git -C "%USB_PATH%." merge-base --is-ancestor %PC_HEAD% %USB_HEAD% 2>nul
if not errorlevel 1 goto :actualizar_pc

:: El PC contiene todo lo de la USB y mas -> no tocar nada
git merge-base --is-ancestor %USB_HEAD% %PC_HEAD% 2>nul
if not errorlevel 1 (
    echo [AVISO] El PC tiene commits que la USB no tiene. Ejecuta finalizar_sesion.bat al terminar.
    goto :git_ok
)

:: Ninguno es ancestro del otro -> divergieron
echo.
echo [PELIGRO] El historial del PC y el de la USB DIVERGIERON.
echo No se toco nada. Revisa con: git log --oneline --all
pause
exit /b 1

:actualizar_pc
echo La USB tiene commits mas nuevos. Actualizando historial del PC...

:: Respaldo completo (todas las ramas, tags y stash) ANTES de reemplazar el .git
if not defined PC_HEAD goto :copiar_git
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
set BUNDLE=%BACKUP_DIR%\respaldo_pc_%RANDOM%%RANDOM%.bundle
git bundle create "%BUNDLE%" --all >nul 2>&1
if errorlevel 1 goto :fallo_respaldo
echo [OK] Respaldo del historial del PC: %BUNDLE%

:copiar_git
robocopy "%USB_PATH%.git" "%PC_WORK%\.git" /MIR >nul
if errorlevel 8 goto :fallo
goto :git_ok

:git_ok
echo [OK] Historial verificado.

:: --- 4. ENTORNO VIRTUAL ---
:: Si la carpeta existe pero esta incompleta/rota (sin python.exe), se recrea (es regenerable)
if exist "%PC_WORK%\env_erp" if not exist "%PC_WORK%\env_erp\Scripts\python.exe" (
    echo [AVISO] env_erp incompleto. Recreando...
    rmdir /s /q "%PC_WORK%\env_erp"
)

if not exist "%PC_WORK%\env_erp\Scripts\python.exe" (
    echo Creando entorno virtual en la PC...
    python -m virtualenv "%PC_WORK%\env_erp" >nul 2>&1
    if errorlevel 1 python -m venv "%PC_WORK%\env_erp"
    if not exist "%PC_WORK%\env_erp\Scripts\python.exe" goto :fallo_env
    if exist "%PC_WORK%\requirements.txt" (
        echo Instalando dependencias...
        "%PC_WORK%\env_erp\Scripts\python.exe" -m pip install -r "%PC_WORK%\requirements.txt" --quiet
    )
    echo [OK] Entorno virtual creado.
)
SET PATH=%PC_WORK%\env_erp\Scripts;%PATH%
echo [OK] Entorno virtual activo.

:: --- 5. LISTO ---
cd /d "%PC_WORK%"
echo.
echo VERSIONES ACTIVAS:
python --version
git --version
echo.
git log --oneline -3
echo.
echo --- RECUERDA EJECUTAR finalizar_sesion.bat AL TERMINAR ---
cmd /k "echo ERP listo en %PC_WORK%"
exit /b 0

:fallo
echo.
echo [ERROR] La copia desde la USB fallo. No empieces a trabajar.
pause
exit /b 1

:fallo_respaldo
echo.
echo [ERROR] No se pudo crear el respaldo del historial del PC.
echo Por seguridad NO se reemplazo el .git. No empieces a trabajar.
pause
exit /b 1

:fallo_env
echo.
echo [ERROR] No se pudo crear el entorno virtual en %PC_WORK%\env_erp
echo Verifica que Python_Portable este completo en la USB.
pause
exit /b 1
