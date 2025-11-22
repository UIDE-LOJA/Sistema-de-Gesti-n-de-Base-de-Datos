@echo off
REM ============================================================================
REM Script Batch para Carga Completa de Datos - Windows
REM Curso: Sistemas de Gestión de Bases de Datos (SGBD-ASC)
REM Semana: 05
REM ============================================================================

echo.
echo ========================================================================
echo   CARGA COMPLETA DE BASE DE DATOS - AIRLINE LOYALTY PROGRAM
echo ========================================================================
echo.

REM Configuración
set MYSQL_PATH="C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
set MYSQL_USER=root

REM Solicitar contraseña
set /p MYSQL_PASS="Ingrese la contraseña de MySQL: "

echo.
echo ========================================================================
echo   PASO 1: Creando base de datos y tablas
echo ========================================================================
echo.

%MYSQL_PATH% -u %MYSQL_USER% -p%MYSQL_PASS% < 01_crear_base_datos_airline_loyalty.sql
if errorlevel 1 (
    echo ERROR: No se pudo crear la base de datos
    pause
    exit /b 1
)

echo OK - Base de datos creada

echo.
echo ========================================================================
echo   PASO 2: Cargando datos de calendario (2,559 registros)
echo ========================================================================
echo.

%MYSQL_PATH% -u %MYSQL_USER% -p%MYSQL_PASS% airline_loyalty_db < 02_cargar_datos_calendar.sql
if errorlevel 1 (
    echo ERROR: No se pudieron cargar los datos de calendario
    pause
    exit /b 1
)

echo OK - Calendario cargado

echo.
echo ========================================================================
echo   PASO 3: Cargando datos de clientes (16,739 registros)
echo ========================================================================
echo.

%MYSQL_PATH% -u %MYSQL_USER% -p%MYSQL_PASS% airline_loyalty_db < 03_cargar_datos_customer_loyalty.sql
if errorlevel 1 (
    echo ERROR: No se pudieron cargar los datos de clientes
    pause
    exit /b 1
)

echo OK - Clientes cargados

echo.
echo ========================================================================
echo   PASO 4: Cargando actividad de vuelos (392,938 registros)
echo   ADVERTENCIA: Este paso puede tardar varios minutos...
echo ========================================================================
echo.

%MYSQL_PATH% -u %MYSQL_USER% -p%MYSQL_PASS% airline_loyalty_db < 04_cargar_datos_flight_activity.sql
if errorlevel 1 (
    echo ERROR: No se pudieron cargar los datos de actividad
    pause
    exit /b 1
)

echo OK - Actividad de vuelos cargada

echo.
echo ========================================================================
echo   VERIFICACION FINAL
echo ========================================================================
echo.

%MYSQL_PATH% -u %MYSQL_USER% -p%MYSQL_PASS% airline_loyalty_db -e "SELECT 'calendar' as tabla, COUNT(*) as registros FROM calendar UNION ALL SELECT 'customer_loyalty_history', COUNT(*) FROM customer_loyalty_history UNION ALL SELECT 'customer_flight_activity', COUNT(*) FROM customer_flight_activity;"

echo.
echo ========================================================================
echo   PROCESO COMPLETADO EXITOSAMENTE
echo ========================================================================
echo.
echo   Base de datos: airline_loyalty_db
echo   Tablas creadas: 3
echo   Vistas creadas: 3
echo   Total de registros: 412,236
echo.
echo ========================================================================
echo.

pause
