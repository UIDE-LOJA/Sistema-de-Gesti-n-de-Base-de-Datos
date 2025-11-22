-- ============================================================================
-- SCRIPT: Limpiar y Reiniciar Base de Datos
-- CURSO: Sistemas de Gestión de Bases de Datos (SGBD-ASC)
-- SEMANA: 05
-- DESCRIPCIÓN: Elimina la base de datos para poder reiniciar la carga
-- USO: Ejecutar este script si necesitas reintentar la carga desde cero
-- ============================================================================

-- Advertencia
SELECT '
╔════════════════════════════════════════════════════════════════════════════╗
║                                                                            ║
║  ADVERTENCIA: Este script eliminará TODA la base de datos                 ║
║               airline_loyalty_db y todos sus datos                         ║
║                                                                            ║
║  Solo ejecuta este script si necesitas reiniciar la carga desde cero      ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝
' AS ADVERTENCIA;

-- Eliminar la base de datos
DROP DATABASE IF EXISTS airline_loyalty_db;

SELECT 'Base de datos eliminada. Ahora puedes ejecutar la carga nuevamente.' AS status;

-- Instrucciones
SELECT '
Próximos pasos:

1. Ejecuta el script de carga nuevamente:
   - Doble clic en: ejecutar_carga_completa.bat
   
   O manualmente:
   - mysql -u root -p < 01_crear_base_datos_airline_loyalty.sql
   - mysql -u root -p airline_loyalty_db < 02_cargar_datos_calendar.sql
   - mysql -u root -p airline_loyalty_db < 03_cargar_datos_customer_loyalty.sql
   - mysql -u root -p airline_loyalty_db < 04_cargar_datos_flight_activity.sql

' AS instrucciones;
