@echo off
TITLE ERP Django - Guardando Sesion
COLOR 0E

:: --- 1. RUTAS ---
SET PC_WORK=C:\Temp_Workspace_ERP
SET USB_PATH=%~dp0
SET BACKUP_DIR=C:\Temp_Workspace_ERP_respaldos
SET PATH=%USB_PATH%Git_Portable\cmd;%USB_PATH%Git_Portable\ucrt64\bin;%PATH%

:: safe.directory solo para esta sesion (no toca el config global del PC)
SET GIT_CONFIG_COUNT=1
SET GIT_CONFIG_KEY_0=safe.directory
SET GIT_CONFIG_VALUE_0=*

echo ==================================================
echo  ERP DJANGO :: PC ^-^> USB (RESPALDO)
echo ==================================================

:: --- 2. VERIFICAR QUE EXISTE EL TALLER Y SU REPO ---
if not exist "%PC_WORK%" (
    echo [ERROR] No existe %PC_WORK%
    echo Ejecuta primero iniciar_sesion.bat
    pause
    exit /b 1
)
if not exist "%PC_WORK%\.git" (
    echo [ERROR] %PC_WORK% no tiene repositorio Git.
    echo Ejecuta primero iniciar_sesion.bat
    pause
    exit /b 1
)

cd /d "%PC_WORK%"

:: --- 3. CAMBIOS SIN COMMIT ---
set DIRTY=
for /f "delims=" %%i in ('git status --porcelain 2^>nul') do set DIRTY=1
if not defined DIRTY goto :push

echo.
git status --short
echo.
echo [ATENCION] Hay cambios SIN commit.
echo   C = Hacer commit automatico de respaldo y continuar
echo   N = Continuar SIN commit, quedan solo como archivos
echo   S = Salir
choice /c CNS /n /m "Elige C, N o S: "
if errorlevel 3 exit /b 1
if errorlevel 2 goto :push

:: Si git no tiene identidad configurada, usar una temporal solo para este commit
set GITNAME=
set GITMAIL=
for /f "delims=" %%n in ('git config user.name 2^>nul') do set GITNAME=%%n
for /f "delims=" %%n in ('git config user.email 2^>nul') do set GITMAIL=%%n
if not defined GITNAME (
    set GIT_AUTHOR_NAME=ERP Sesion
    set GIT_COMMITTER_NAME=ERP Sesion
)
if not defined GITMAIL (
    set GIT_AUTHOR_EMAIL=erp@local
    set GIT_COMMITTER_EMAIL=erp@local
)

git add -A
git commit -m "Respaldo automatico de sesion %date% %time%" >nul
if errorlevel 1 (
    echo [ERROR] No se pudo crear el commit de respaldo.
    pause
    exit /b 1
)
echo [OK] Commit de respaldo creado.

:: --- 4. SUBIR A GITHUB (si hay internet) ---
:push
echo.
echo Subiendo a GitHub...
git push
if errorlevel 1 (
    echo [AVISO] No se pudo hacer push. Los commits quedaran solo en la USB.
    echo         Si es la primera vez, usa: git push -u origin main
)

:: --- 5. PROTECCION: no pisar commits de la USB con un historial mas viejo ---
:: Se verifica ANTES de copiar nada a la USB.
set PC_HEAD=
for /f %%h in ('git rev-parse HEAD 2^>nul') do set PC_HEAD=%%h
if not defined PC_HEAD (
    echo [ERROR] El repo del PC no tiene commits. Respaldo cancelado.
    pause
    exit /b 1
)

set USB_HEAD=
if exist "%USB_PATH%.git" for /f %%h in ('git -C "%USB_PATH%." rev-parse HEAD 2^>nul') do set USB_HEAD=%%h
if not defined USB_HEAD goto :copiar_codigo
if "%USB_HEAD%"=="%PC_HEAD%" goto :copiar_codigo

:: La USB es ancestro del PC -> el PC tiene todo y mas, es seguro continuar
git merge-base --is-ancestor %USB_HEAD% %PC_HEAD% 2>nul
if not errorlevel 1 goto :copiar_codigo

echo.
echo [PELIGRO] La USB tiene commits que el PC NO tiene.
echo Si sigues, se PERDERIAN. Respaldo cancelado, no se copio nada.
echo Revisa con: git log --oneline --all
pause
exit /b 1

:: --- 6. CODIGO Y ARCHIVOS A LA USB (/XO: no pisa archivos mas nuevos de la USB) ---
:copiar_codigo
echo.
echo Guardando archivos en la USB...
robocopy "%PC_WORK%" "%USB_PATH%." /E /XO /XD .git .git_tmp .git_old env_erp venv __pycache__ staticfiles Git_Portable Python_Portable WorkSpace_ERP "System Volume Information" /XF *.pyc >nul
if %errorlevel% GEQ 8 goto :fallo

:: --- 7. EL .GIT (LO MAS IMPORTANTE) ---
:: Respaldo previo del historial de la USB, solo si va a cambiar
if not defined USB_HEAD goto :copiar_git
if "%USB_HEAD%"=="%PC_HEAD%" goto :copiar_git
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
set BUNDLE=%BACKUP_DIR%\respaldo_usb_%RANDOM%%RANDOM%.bundle
git -C "%USB_PATH%." bundle create "%BUNDLE%" --all >nul 2>&1
if errorlevel 1 goto :fallo_respaldo
echo [OK] Respaldo del historial anterior de la USB: %BUNDLE%

:: Copiar a una carpeta temporal, verificar y solo entonces reemplazar
:copiar_git
robocopy "%PC_WORK%\.git" "%USB_PATH%.git_tmp" /MIR >nul
if %errorlevel% GEQ 8 goto :fallo

set TMP_HEAD=
for /f %%h in ('git --git-dir="%USB_PATH%.git_tmp" rev-parse HEAD 2^>nul') do set TMP_HEAD=%%h
if not "%TMP_HEAD%"=="%PC_HEAD%" goto :fallo_verif

if exist "%USB_PATH%.git_old" rmdir /s /q "%USB_PATH%.git_old"
if exist "%USB_PATH%.git" ren "%USB_PATH%.git" .git_old || goto :fallo_swap
ren "%USB_PATH%.git_tmp" .git || goto :fallo_swap
attrib +h "%USB_PATH%.git" >nul 2>&1
if exist "%USB_PATH%.git_old" rmdir /s /q "%USB_PATH%.git_old"

echo.
echo Ultimos commits guardados en la USB:
git -C "%USB_PATH%." log --oneline -3

echo.
echo ==================================================
echo  RESPALDO COMPLETADO. Es seguro retirar la USB.
echo ==================================================
pause
exit /b 0

:fallo
echo.
echo [ERROR] El respaldo fallo (codigo %errorlevel%). NO retires la USB.
pause
exit /b 1

:fallo_respaldo
echo.
echo [ERROR] No se pudo respaldar el historial anterior de la USB.
echo Por seguridad NO se reemplazo el .git. NO retires la USB.
pause
exit /b 1

:fallo_verif
echo.
echo [ERROR] La copia del .git no coincide con el del PC.
echo El .git de la USB NO fue reemplazado y sigue intacto. NO retires la USB.
pause
exit /b 1

:fallo_swap
echo.
echo [ERROR] No se pudo reemplazar el .git de la USB.
echo Si en la USB no existe la carpeta .git pero si .git_old,
echo renombra .git_old a .git para recuperar el historial anterior.
pause
exit /b 1
