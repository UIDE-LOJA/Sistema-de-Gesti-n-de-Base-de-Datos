-- ============================================================================
-- SCRIPT: Carga de Datos - Tabla Calendar
-- CURSO: Sistemas de Gestión de Bases de Datos (SGBD-ASC)
-- SEMANA: 05
-- DESCRIPCIÓN: Script para cargar datos en la tabla calendar desde CSV
-- NOTA: Este script usa LOAD DATA INFILE para cargar el archivo Calendar.csv
-- ============================================================================

USE airline_loyalty_db;

-- Deshabilitar verificaciones temporalmente para mejorar rendimiento
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;
SET AUTOCOMMIT = 0;

-- ============================================================================
-- OPCIÓN 1: Carga usando LOAD DATA INFILE (Más rápido)
-- ============================================================================
-- NOTA: Ajustar la ruta del archivo según tu sistema
-- En Windows: 'C:/ruta/al/archivo/Calendar.csv'
-- En Linux/Mac: '/ruta/al/archivo/Calendar.csv'

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Calendar.csv'
INTO TABLE calendar
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(date_id, start_of_year, start_of_quarter, start_of_month)
SET 
    year_num = YEAR(date_id),
    quarter_num = QUARTER(date_id),
    month_num = MONTH(date_id),
    day_of_week = DAYNAME(date_id);

-- ============================================================================
-- OPCIÓN 2: Si LOAD DATA INFILE no está disponible, usar LOAD DATA LOCAL INFILE
-- ============================================================================
-- Descomentar las siguientes líneas si la opción 1 no funciona:

/*
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Calendar.csv'
INTO TABLE calendar
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(date_id, start_of_year, start_of_quarter, start_of_month)
SET 
    year_num = YEAR(date_id),
    quarter_num = QUARTER(date_id),
    month_num = MONTH(date_id),
    day_of_week = DAYNAME(date_id);
*/

-- ============================================================================
-- OPCIÓN 3: Carga manual usando procedimiento almacenado (Alternativa)
-- ============================================================================
-- Si ninguna de las opciones anteriores funciona, usar este procedimiento:

/*
DELIMITER $$

CREATE PROCEDURE load_calendar_data()
BEGIN
    DECLARE v_date DATE;
    DECLARE v_start_date DATE DEFAULT '2012-01-01';
    DECLARE v_end_date DATE DEFAULT '2018-12-31';
    
    SET v_date = v_start_date;
    
    WHILE v_date <= v_end_date DO
        INSERT INTO calendar (
            date_id,
            start_of_year,
            start_of_quarter,
            start_of_month,
            year_num,
            quarter_num,
            month_num,
            day_of_week
        ) VALUES (
            v_date,
            DATE_FORMAT(v_date, '%Y-01-01'),
            DATE_FORMAT(v_date, CONCAT('%Y-', LPAD((QUARTER(v_date) - 1) * 3 + 1, 2, '0'), '-01')),
            DATE_FORMAT(v_date, '%Y-%m-01'),
            YEAR(v_date),
            QUARTER(v_date),
            MONTH(v_date),
            DAYNAME(v_date)
        );
        
        SET v_date = DATE_ADD(v_date, INTERVAL 1 DAY);
    END WHILE;
END$$

DELIMITER ;

-- Ejecutar el procedimiento
CALL load_calendar_data();

-- Eliminar el procedimiento después de usarlo
DROP PROCEDURE IF EXISTS load_calendar_data;
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
SELECT 
    COUNT(*) as total_records,
    MIN(date_id) as fecha_inicio,
    MAX(date_id) as fecha_fin,
    COUNT(DISTINCT year_num) as total_years
FROM calendar;

SELECT 'Datos de calendar cargados exitosamente' AS status;

-- Mostrar muestra de datos
SELECT * FROM calendar LIMIT 10;
