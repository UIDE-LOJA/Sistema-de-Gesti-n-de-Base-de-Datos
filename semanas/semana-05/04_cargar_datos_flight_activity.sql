-- ============================================================================
-- SCRIPT: Carga de Datos - Tabla Customer Flight Activity
-- CURSO: Sistemas de Gestión de Bases de Datos (SGBD-ASC)
-- SEMANA: 05
-- DESCRIPCIÓN: Script para cargar actividad de vuelos desde CSV
-- REGISTROS ESPERADOS: ~392,938 registros
-- ADVERTENCIA: Este proceso puede tomar varios minutos debido al volumen
-- ============================================================================

USE airline_loyalty_db;

-- Deshabilitar verificaciones temporalmente para mejorar rendimiento
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;
SET AUTOCOMMIT = 0;

-- Aumentar el tamaño del buffer para mejorar rendimiento
SET SESSION bulk_insert_buffer_size = 256 * 1024 * 1024;

-- ============================================================================
-- OPCIÓN 1: Carga usando LOAD DATA INFILE (Más rápido - RECOMENDADO)
-- ============================================================================
-- NOTA: Ruta configurada para MySQL Server 8.0 en Windows
-- Si tu instalación es diferente, ajusta la ruta según tu sistema

-- Crear tabla temporal para cargar datos
CREATE TEMPORARY TABLE temp_flight_activity (
    loyalty_number INT,
    year INT,
    month INT,
    total_flights INT,
    distance INT,
    points_accumulated INT,
    points_redeemed INT,
    dollar_cost_points_redeemed DECIMAL(10,2)
) ENGINE=MEMORY;

-- Cargar datos en tabla temporal
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customer Flight Activity.csv'
INTO TABLE temp_flight_activity
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    loyalty_number,
    year,
    month,
    total_flights,
    distance,
    points_accumulated,
    points_redeemed,
    dollar_cost_points_redeemed
);

-- Insertar en tabla final eliminando duplicados (sumando valores)
INSERT INTO customer_flight_activity 
(loyalty_number, year, month, total_flights, distance, points_accumulated, points_redeemed, dollar_cost_points_redeemed)
SELECT 
    loyalty_number,
    year,
    month,
    SUM(total_flights) as total_flights,
    SUM(distance) as distance,
    SUM(points_accumulated) as points_accumulated,
    SUM(points_redeemed) as points_redeemed,
    SUM(dollar_cost_points_redeemed) as dollar_cost_points_redeemed
FROM temp_flight_activity
GROUP BY loyalty_number, year, month;

-- Eliminar tabla temporal
DROP TEMPORARY TABLE temp_flight_activity;

-- ============================================================================
-- OPCIÓN 2: Si LOAD DATA INFILE no está disponible, usar LOAD DATA LOCAL INFILE
-- ============================================================================
-- Descomentar las siguientes líneas si la opción 1 no funciona:

/*
-- Crear tabla temporal para cargar datos
CREATE TEMPORARY TABLE temp_flight_activity (
    loyalty_number INT,
    year INT,
    month INT,
    total_flights INT,
    distance INT,
    points_accumulated INT,
    points_redeemed INT,
    dollar_cost_points_redeemed DECIMAL(10,2)
) ENGINE=MEMORY;

-- Cargar datos en tabla temporal
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customer Flight Activity.csv'
INTO TABLE temp_flight_activity
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    loyalty_number,
    year,
    month,
    total_flights,
    distance,
    points_accumulated,
    points_redeemed,
    dollar_cost_points_redeemed
);

-- Insertar en tabla final eliminando duplicados (sumando valores)
INSERT INTO customer_flight_activity 
(loyalty_number, year, month, total_flights, distance, points_accumulated, points_redeemed, dollar_cost_points_redeemed)
SELECT 
    loyalty_number,
    year,
    month,
    SUM(total_flights) as total_flights,
    SUM(distance) as distance,
    SUM(points_accumulated) as points_accumulated,
    SUM(points_redeemed) as points_redeemed,
    SUM(dollar_cost_points_redeemed) as dollar_cost_points_redeemed
FROM temp_flight_activity
GROUP BY loyalty_number, year, month;

-- Eliminar tabla temporal
DROP TEMPORARY TABLE temp_flight_activity;
*/

-- Confirmar transacción
COMMIT;

-- Restaurar configuraciones
SET FOREIGN_KEY_CHECKS = 1;
SET UNIQUE_CHECKS = 1;
SET AUTOCOMMIT = 1;

-- ============================================================================
-- VERIFICACIÓN DE CARGA
-- ============================================================================

-- Contar registros totales
SELECT 
    COUNT(*) as total_records,
    COUNT(DISTINCT loyalty_number) as unique_customers,
    MIN(year) as first_year,
    MAX(year) as last_year
FROM customer_flight_activity;

-- Actividad por año
SELECT 
    year,
    COUNT(*) as total_records,
    COUNT(DISTINCT loyalty_number) as active_customers,
    SUM(total_flights) as total_flights,
    SUM(distance) as total_distance_km,
    SUM(points_accumulated) as total_points_accumulated,
    SUM(points_redeemed) as total_points_redeemed,
    ROUND(SUM(dollar_cost_points_redeemed), 2) as total_dollar_cost
FROM customer_flight_activity
GROUP BY year
ORDER BY year;

-- Actividad por mes en 2018
SELECT 
    month,
    COUNT(DISTINCT loyalty_number) as active_customers,
    SUM(total_flights) as total_flights,
    ROUND(AVG(distance), 2) as avg_distance_km,
    SUM(points_accumulated) as total_points_accumulated
FROM customer_flight_activity
WHERE year = 2018
GROUP BY month
ORDER BY month;

-- Top 10 clientes más activos (por total de vuelos)
SELECT 
    cfa.loyalty_number,
    clh.loyalty_card,
    clh.province,
    SUM(cfa.total_flights) as lifetime_flights,
    SUM(cfa.distance) as lifetime_distance_km,
    SUM(cfa.points_accumulated) as lifetime_points
FROM customer_flight_activity cfa
JOIN customer_loyalty_history clh ON cfa.loyalty_number = clh.loyalty_number
GROUP BY cfa.loyalty_number, clh.loyalty_card, clh.province
ORDER BY lifetime_flights DESC
LIMIT 10;

-- Clientes con mayor acumulación de puntos
SELECT 
    cfa.loyalty_number,
    clh.loyalty_card,
    SUM(cfa.points_accumulated) as total_points_accumulated,
    SUM(cfa.points_redeemed) as total_points_redeemed,
    SUM(cfa.points_accumulated) - SUM(cfa.points_redeemed) as points_balance
FROM customer_flight_activity cfa
JOIN customer_loyalty_history clh ON cfa.loyalty_number = clh.loyalty_number
GROUP BY cfa.loyalty_number, clh.loyalty_card
ORDER BY total_points_accumulated DESC
LIMIT 10;

-- Análisis de canje de puntos
SELECT 
    CASE 
        WHEN points_redeemed > 0 THEN 'Con canje'
        ELSE 'Sin canje'
    END as redemption_status,
    COUNT(*) as record_count,
    SUM(points_redeemed) as total_points_redeemed,
    ROUND(SUM(dollar_cost_points_redeemed), 2) as total_dollar_value
FROM customer_flight_activity
GROUP BY redemption_status;

-- Estadísticas generales
SELECT 
    'Total de registros' as metric,
    COUNT(*) as value
FROM customer_flight_activity
UNION ALL
SELECT 
    'Clientes únicos',
    COUNT(DISTINCT loyalty_number)
FROM customer_flight_activity
UNION ALL
SELECT 
    'Total de vuelos',
    SUM(total_flights)
FROM customer_flight_activity
UNION ALL
SELECT 
    'Distancia total (km)',
    SUM(distance)
FROM customer_flight_activity
UNION ALL
SELECT 
    'Puntos acumulados',
    SUM(points_accumulated)
FROM customer_flight_activity
UNION ALL
SELECT 
    'Puntos canjeados',
    SUM(points_redeemed)
FROM customer_flight_activity;

-- Verificar integridad referencial
SELECT 
    COUNT(*) as orphan_records
FROM customer_flight_activity cfa
LEFT JOIN customer_loyalty_history clh ON cfa.loyalty_number = clh.loyalty_number
WHERE clh.loyalty_number IS NULL;

SELECT 'Datos de customer_flight_activity cargados exitosamente' AS status;

-- Mostrar muestra de datos
SELECT * FROM customer_flight_activity LIMIT 10;
