@echo off
REM ============================================================================
REM Script para Limpiar Base de Datos
REM ============================================================================

echo.
echo ========================================================================
echo   LIMPIAR BASE DE DATOS - AIRLINE LOYALTY PROGRAM
echo ========================================================================
echo.
echo ADVERTENCIA: Este script eliminara TODA la base de datos
echo              airline_loyalty_db y todos sus datos
echo.
echo Solo continua si necesitas reiniciar la carga desde cero
echo.
pause

REM Configuración
set MYSQL_PATH="C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
set MYSQL_USER=root

REM Solicitar contraseña
set /p MYSQL_PASS="Ingrese la contraseña de MySQL: "

echo.
echo Eliminando base de datos...
echo.

%MYSQL_PATH% -u %MYSQL_USER% -p%MYSQL_PASS% < 00_limpiar_y_reiniciar.sql

if errorlevel 1 (
    echo ERROR: No se pudo eliminar la base de datos
    pause
    exit /b 1
)

echo.
echo ========================================================================
echo   BASE DE DATOS ELIMINADA
echo ========================================================================
echo.
echo Ahora puedes ejecutar la carga nuevamente:
echo   - Doble clic en: ejecutar_carga_completa.bat
echo.
echo ========================================================================
echo.

pause
