-- ============================================================================
-- SCRIPT: Carga de Datos - Tabla Customer Loyalty History
-- CURSO: Sistemas de Gestión de Bases de Datos (SGBD-ASC)
-- SEMANA: 05
-- DESCRIPCIÓN: Script para cargar datos de clientes desde CSV
-- REGISTROS ESPERADOS: ~16,739 clientes
-- ============================================================================

USE airline_loyalty_db;

-- Deshabilitar verificaciones temporalmente para mejorar rendimiento
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;
SET AUTOCOMMIT = 0;

-- ============================================================================
-- OPCIÓN 1: Carga usando LOAD DATA INFILE (Más rápido)
-- ============================================================================
-- NOTA: Ruta configurada para MySQL Server 8.0 en Windows
-- Si tu instalación es diferente, ajusta la ruta según tu sistema

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customer Loyalty History.csv'
INTO TABLE customer_loyalty_history
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    loyalty_number,
    country,
    province,
    city,
    postal_code,
    gender,
    education,
    @salary,
    marital_status,
    loyalty_card,
    clv,
    enrollment_type,
    enrollment_year,
    enrollment_month,
    @cancellation_year,
    @cancellation_month
)
SET 
    salary = IF(@salary = '', NULL, @salary),
    cancellation_year = IF(@cancellation_year = '', NULL, @cancellation_year),
    cancellation_month = IF(@cancellation_month = '', NULL, @cancellation_month);

-- ============================================================================
-- OPCIÓN 2: Si LOAD DATA INFILE no está disponible, usar LOAD DATA LOCAL INFILE
-- ============================================================================
-- Descomentar las siguientes líneas si la opción 1 no funciona:

/*
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customer Loyalty History.csv'
INTO TABLE customer_loyalty_history
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    loyalty_number,
    country,
    province,
    city,
    postal_code,
    gender,
    education,
    @salary,
    marital_status,
    loyalty_card,
    clv,
    enrollment_type,
    enrollment_year,
    enrollment_month,
    @cancellation_year,
    @cancellation_month
)
SET 
    salary = IF(@salary = '', NULL, @salary),
    cancellation_year = IF(@cancellation_year = '', NULL, @cancellation_year),
    cancellation_month = IF(@cancellation_month = '', NULL, @cancellation_month);
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
    COUNT(*) as total_customers,
    COUNT(DISTINCT loyalty_number) as unique_customers
FROM customer_loyalty_history;

-- Distribución por nivel de tarjeta
SELECT 
    loyalty_card,
    COUNT(*) as customer_count,
    ROUND(AVG(clv), 2) as avg_clv,
    ROUND(AVG(salary), 2) as avg_salary
FROM customer_loyalty_history
GROUP BY loyalty_card
ORDER BY 
    FIELD(loyalty_card, 'Star', 'Nova', 'Aurora');

-- Distribución por provincia
SELECT 
    province,
    COUNT(*) as customer_count,
    ROUND(AVG(clv), 2) as avg_clv
FROM customer_loyalty_history
GROUP BY province
ORDER BY customer_count DESC
LIMIT 10;

-- Clientes con cancelación
SELECT 
    COUNT(*) as cancelled_customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customer_loyalty_history), 2) as cancellation_rate_pct
FROM customer_loyalty_history
WHERE cancellation_year IS NOT NULL;

-- Distribución por tipo de inscripción
SELECT 
    enrollment_type,
    COUNT(*) as customer_count,
    MIN(enrollment_year) as first_enrollment,
    MAX(enrollment_year) as last_enrollment
FROM customer_loyalty_history
GROUP BY enrollment_type;

-- Distribución por nivel educativo
SELECT 
    education,
    COUNT(*) as customer_count,
    ROUND(AVG(salary), 2) as avg_salary
FROM customer_loyalty_history
WHERE education IS NOT NULL
GROUP BY education
ORDER BY customer_count DESC;

-- Distribución por género
SELECT 
    gender,
    COUNT(*) as customer_count,
    ROUND(AVG(clv), 2) as avg_clv
FROM customer_loyalty_history
WHERE gender IS NOT NULL
GROUP BY gender;

-- Top 10 clientes por CLV
SELECT 
    loyalty_number,
    loyalty_card,
    province,
    city,
    clv,
    enrollment_year
FROM customer_loyalty_history
ORDER BY clv DESC
LIMIT 10;

SELECT 'Datos de customer_loyalty_history cargados exitosamente' AS status;

-- Mostrar muestra de datos
SELECT * FROM customer_loyalty_history LIMIT 5;
