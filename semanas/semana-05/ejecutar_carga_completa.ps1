# ============================================================================
# Script PowerShell para Carga Completa de Datos
# Curso: Sistemas de Gestión de Bases de Datos (SGBD-ASC)
# Semana: 05
# ============================================================================

Write-Host ""
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host "  CARGA COMPLETA DE BASE DE DATOS - AIRLINE LOYALTY PROGRAM" -ForegroundColor Cyan
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host ""

# Configuración
$mysqlPath = "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
$mysqlUser = "root"

# Verificar que MySQL existe
if (-not (Test-Path $mysqlPath)) {
    Write-Host "ERROR: No se encontró MySQL en: $mysqlPath" -ForegroundColor Red
    Write-Host "Por favor, ajusta la ruta en el script" -ForegroundColor Yellow
    Read-Host "Presiona Enter para salir"
    exit 1
}

# Solicitar contraseña de forma segura
$mysqlPass = Read-Host "Ingrese la contraseña de MySQL" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($mysqlPass)
$mysqlPassPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# Función para ejecutar script SQL
function Execute-SQLScript {
    param(
        [string]$scriptFile,
        [string]$database = ""
    )
    
    if ($database -eq "") {
        $cmd = "& `"$mysqlPath`" -u $mysqlUser -p$mysqlPassPlain < `"$scriptFile`""
    } else {
        $cmd = "& `"$mysqlPath`" -u $mysqlUser -p$mysqlPassPlain $database < `"$scriptFile`""
    }
    
    Invoke-Expression $cmd
    return $LASTEXITCODE
}

# PASO 1: Crear base de datos
Write-Host ""
Write-Host "========================================================================" -ForegroundColor Green
Write-Host "  PASO 1: Creando base de datos y tablas" -ForegroundColor Green
Write-Host "========================================================================" -ForegroundColor Green
Write-Host ""

$result = Execute-SQLScript "01_crear_base_datos_airline_loyalty.sql"
if ($result -ne 0) {
    Write-Host "ERROR: No se pudo crear la base de datos" -ForegroundColor Red
    Read-Host "Presiona Enter para salir"
    exit 1
}
Write-Host "OK - Base de datos creada" -ForegroundColor Green

# PASO 2: Cargar calendario
Write-Host ""
Write-Host "========================================================================" -ForegroundColor Green
Write-Host "  PASO 2: Cargando datos de calendario (2,559 registros)" -ForegroundColor Green
Write-Host "========================================================================" -ForegroundColor Green
Write-Host ""

$result = Execute-SQLScript "02_cargar_datos_calendar.sql" "airline_loyalty_db"
if ($result -ne 0) {
    Write-Host "ERROR: No se pudieron cargar los datos de calendario" -ForegroundColor Red
    Read-Host "Presiona Enter para salir"
    exit 1
}
Write-Host "OK - Calendario cargado" -ForegroundColor Green

# PASO 3: Cargar clientes
Write-Host ""
Write-Host "========================================================================" -ForegroundColor Green
Write-Host "  PASO 3: Cargando datos de clientes (16,739 registros)" -ForegroundColor Green
Write-Host "========================================================================" -ForegroundColor Green
Write-Host ""

$result = Execute-SQLScript "03_cargar_datos_customer_loyalty.sql" "airline_loyalty_db"
if ($result -ne 0) {
    Write-Host "ERROR: No se pudieron cargar los datos de clientes" -ForegroundColor Red
    Read-Host "Presiona Enter para salir"
    exit 1
}
Write-Host "OK - Clientes cargados" -ForegroundColor Green

# PASO 4: Cargar actividad de vuelos
Write-Host ""
Write-Host "========================================================================" -ForegroundColor Yellow
Write-Host "  PASO 4: Cargando actividad de vuelos (392,938 registros)" -ForegroundColor Yellow
Write-Host "  ADVERTENCIA: Este paso puede tardar varios minutos..." -ForegroundColor Yellow
Write-Host "========================================================================" -ForegroundColor Yellow
Write-Host ""

$result = Execute-SQLScript "04_cargar_datos_flight_activity.sql" "airline_loyalty_db"
if ($result -ne 0) {
    Write-Host "ERROR: No se pudieron cargar los datos de actividad" -ForegroundColor Red
    Read-Host "Presiona Enter para salir"
    exit 1
}
Write-Host "OK - Actividad de vuelos cargada" -ForegroundColor Green

# Verificación final
Write-Host ""
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host "  VERIFICACION FINAL" -ForegroundColor Cyan
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host ""

$query = "SELECT 'calendar' as tabla, COUNT(*) as registros FROM calendar UNION ALL SELECT 'customer_loyalty_history', COUNT(*) FROM customer_loyalty_history UNION ALL SELECT 'customer_flight_activity', COUNT(*) FROM customer_flight_activity;"
& "$mysqlPath" -u $mysqlUser -p$mysqlPassPlain airline_loyalty_db -e $query

Write-Host ""
Write-Host "========================================================================" -ForegroundColor Green
Write-Host "  PROCESO COMPLETADO EXITOSAMENTE" -ForegroundColor Green
Write-Host "========================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Base de datos: airline_loyalty_db" -ForegroundColor White
Write-Host "  Tablas creadas: 3" -ForegroundColor White
Write-Host "  Vistas creadas: 3" -ForegroundColor White
Write-Host "  Total de registros: 412,236" -ForegroundColor White
Write-Host ""
Write-Host "========================================================================" -ForegroundColor Green
Write-Host ""

Read-Host "Presiona Enter para salir"
