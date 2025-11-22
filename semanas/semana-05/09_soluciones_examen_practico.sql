-- ============================================================================
-- SOLUCIONES - EJERCICIOS DE EXAMEN PRÁCTICO
-- CURSO: Sistemas de Gestión de Bases de Datos (SGBD-ASC)
-- SEMANA: 05
-- DESCRIPCIÓN: Soluciones de los ejercicios prácticos
-- NOTA: ESTE ARCHIVO ES SOLO PARA EL INSTRUCTOR
-- ============================================================================

USE airline_loyalty_db;

-- ============================================================================
-- SECCIÓN 1: CONSULTAS BÁSICAS (20 puntos)
-- ============================================================================

-- EJERCICIO 1.1 (5 puntos)
SELECT 
    loyalty_number,
    city,
    clv,
    enrollment_year
FROM customer_loyalty_history
WHERE province = 'Ontario'
    AND loyalty_card = 'Aurora'
ORDER BY clv DESC;

-- EJERCICIO 1.2 (5 puntos)
SELECT 
    education,
    COUNT(*) as cantidad_clientes
FROM customer_loyalty_history
WHERE education IS NOT NULL
GROUP BY education
ORDER BY cantidad_clientes DESC;

-- EJERCICIO 1.3 (5 puntos)
SELECT 
    province,
    ROUND(AVG(clv), 2) as clv_promedio,
    ROUND(MIN(clv), 2) as clv_minimo,
    ROUND(MAX(clv), 2) as clv_maximo,
    COUNT(*) as total_clientes
FROM customer_loyalty_history
GROUP BY province
HAVING COUNT(*) > 100
ORDER BY clv_promedio DESC;

-- EJERCICIO 1.4 (5 puntos)
SELECT 
    cfa.loyalty_number,
    clh.loyalty_card,
    SUM(cfa.points_accumulated) as total_puntos_acumulados
FROM customer_flight_activity cfa
JOIN customer_loyalty_history clh ON cfa.loyalty_number = clh.loyalty_number
GROUP BY cfa.loyalty_number, clh.loyalty_card
ORDER BY total_puntos_acumulados DESC
LIMIT 10;

-- ============================================================================
-- SECCIÓN 2: JOINS Y RELACIONES (25 puntos)
-- ============================================================================

-- EJERCICIO 2.1 (8 puntos)
SELECT 
    clh.loyalty_number,
    CONCAT(clh.city, ', ', clh.province) as nombre_completo,
    clh.loyalty_card,
    SUM(cfa.total_flights) as total_vuelos,
    SUM(cfa.distance) as distancia_total_km
FROM customer_loyalty_history clh
JOIN customer_flight_activity cfa ON clh.loyalty_number = cfa.loyalty_number
WHERE cfa.total_flights > 0
GROUP BY clh.loyalty_number, clh.city, clh.province, clh.loyalty_card
ORDER BY distancia_total_km DESC
LIMIT 20;

-- EJERCICIO 2.2 (8 puntos)
SELECT 
    cfa.month as mes,
    COUNT(DISTINCT cfa.loyalty_number) as clientes_activos,
    SUM(cfa.total_flights) as total_vuelos,
    ROUND(AVG(cfa.distance), 2) as distancia_promedio,
    SUM(cfa.points_accumulated) as puntos_acumulados,
    SUM(cfa.points_redeemed) as puntos_canjeados,
    ROUND(SUM(cfa.points_redeemed) * 100.0 / NULLIF(SUM(cfa.points_accumulated), 0), 2) as tasa_canje_porcentaje
FROM customer_flight_activity cfa
WHERE cfa.year = 2018
GROUP BY cfa.month
ORDER BY cfa.month;

-- EJERCICIO 2.3 (9 puntos)
SELECT 
    clh.enrollment_type,
    COUNT(DISTINCT clh.loyalty_number) as cantidad_clientes,
    ROUND(AVG(clh.clv), 2) as clv_promedio,
    ROUND(AVG(cfa_agg.total_vuelos), 2) as vuelos_promedio,
    ROUND(AVG(cfa_agg.puntos_acumulados), 2) as puntos_promedio
FROM customer_loyalty_history clh
LEFT JOIN (
    SELECT 
        loyalty_number,
        SUM(total_flights) as total_vuelos,
        SUM(points_accumulated) as puntos_acumulados
    FROM customer_flight_activity
    WHERE year = 2018
    GROUP BY loyalty_number
) cfa_agg ON clh.loyalty_number = cfa_agg.loyalty_number
WHERE clh.enrollment_year = 2018
GROUP BY clh.enrollment_type;

-- ============================================================================
-- SECCIÓN 3: SUBCONSULTAS Y AGREGACIONES (25 puntos)
-- ============================================================================

-- EJERCICIO 3.1 (8 puntos)
SELECT 
    clh.loyalty_number,
    clh.province,
    clh.clv,
    ROUND(prov_avg.clv_promedio, 2) as clv_promedio_provincia,
    ROUND(clh.clv - prov_avg.clv_promedio, 2) as diferencia_vs_promedio
FROM customer_loyalty_history clh
JOIN (
    SELECT 
        province,
        AVG(clv) as clv_promedio
    FROM customer_loyalty_history
    GROUP BY province
) prov_avg ON clh.province = prov_avg.province
WHERE clh.clv > prov_avg.clv_promedio
ORDER BY diferencia_vs_promedio DESC
LIMIT 30;

-- EJERCICIO 3.2 (9 puntos)
SELECT 
    cfa.loyalty_number,
    clh.loyalty_card,
    cfa.year,
    cfa.month,
    cfa.total_flights as total_vuelos_ese_mes,
    total_hist.total_vuelos_historico
FROM customer_flight_activity cfa
JOIN customer_loyalty_history clh ON cfa.loyalty_number = clh.loyalty_number
JOIN (
    SELECT 
        loyalty_number,
        SUM(total_flights) as total_vuelos_historico
    FROM customer_flight_activity
    GROUP BY loyalty_number
    HAVING SUM(total_flights) > 20
) total_hist ON cfa.loyalty_number = total_hist.loyalty_number
WHERE cfa.total_flights = (
    SELECT MAX(total_flights)
    FROM customer_flight_activity cfa2
    WHERE cfa2.loyalty_number = cfa.loyalty_number
)
ORDER BY total_vuelos_ese_mes DESC
LIMIT 25;

-- EJERCICIO 3.3 (8 puntos)
SELECT 
    enrollment_year,
    COUNT(*) as total_inscritos,
    COUNT(CASE WHEN cancellation_year IS NULL THEN 1 END) as clientes_activos,
    COUNT(CASE WHEN cancellation_year IS NOT NULL THEN 1 END) as clientes_cancelados,
    ROUND(COUNT(CASE WHEN cancellation_year IS NULL THEN 1 END) * 100.0 / COUNT(*), 2) as tasa_retencion_porcentaje
FROM customer_loyalty_history
GROUP BY enrollment_year
ORDER BY enrollment_year;

-- ============================================================================
-- SECCIÓN 4: WINDOW FUNCTIONS Y CTEs (20 puntos)
-- ============================================================================

-- EJERCICIO 4.1 (10 puntos)
WITH ranked_customers AS (
    SELECT 
        loyalty_number,
        province,
        city,
        loyalty_card,
        clv,
        RANK() OVER (PARTITION BY province ORDER BY clv DESC) as ranking_en_provincia,
        PERCENT_RANK() OVER (PARTITION BY province ORDER BY clv) as percentil_en_provincia
    FROM customer_loyalty_history
    WHERE cancellation_year IS NULL
)
SELECT 
    loyalty_number,
    province,
    city,
    loyalty_card,
    clv,
    ranking_en_provincia,
    ROUND(percentil_en_provincia * 100, 2) as percentil_en_provincia
FROM ranked_customers
WHERE ranking_en_provincia <= 3
ORDER BY province, ranking_en_provincia;

-- EJERCICIO 4.2 (10 puntos)
WITH monthly_activity AS (
    SELECT 
        month as mes,
        SUM(total_flights) as total_vuelos
    FROM customer_flight_activity
    WHERE year = 2018
    GROUP BY month
)
SELECT 
    mes,
    total_vuelos,
    LAG(total_vuelos) OVER (ORDER BY mes) as vuelos_mes_anterior,
    total_vuelos - LAG(total_vuelos) OVER (ORDER BY mes) as crecimiento_absoluto,
    ROUND((total_vuelos - LAG(total_vuelos) OVER (ORDER BY mes)) * 100.0 / 
          NULLIF(LAG(total_vuelos) OVER (ORDER BY mes), 0), 2) as crecimiento_porcentual
FROM monthly_activity
ORDER BY mes;

-- ============================================================================
-- SECCIÓN 5: ANÁLISIS DE NEGOCIO (10 puntos)
-- ============================================================================

-- EJERCICIO 5.1 (10 puntos)
WITH customer_metrics AS (
    SELECT 
        clh.loyalty_number,
        clh.loyalty_card,
        clh.clv,
        MAX(CONCAT(cfa.year, '-', LPAD(cfa.month, 2, '0'))) as ultima_actividad,
        SUM(cfa.total_flights) as total_vuelos
    FROM customer_loyalty_history clh
    LEFT JOIN customer_flight_activity cfa ON clh.loyalty_number = cfa.loyalty_number
    WHERE clh.cancellation_year IS NULL
    GROUP BY clh.loyalty_number, clh.loyalty_card, clh.clv
)
SELECT 
    loyalty_number,
    loyalty_card,
    ultima_actividad,
    total_vuelos,
    clv,
    CASE 
        WHEN ultima_actividad >= '2018-10' THEN 'Reciente'
        WHEN ultima_actividad >= '2018-07' THEN 'Medio'
        ELSE 'Antiguo'
    END as segmento_recency,
    CASE 
        WHEN total_vuelos >= 50 THEN 'Alto'
        WHEN total_vuelos >= 20 THEN 'Medio'
        ELSE 'Bajo'
    END as segmento_frequency,
    CASE 
        WHEN clv >= 10000 THEN 'Alto'
        WHEN clv >= 5000 THEN 'Medio'
        ELSE 'Bajo'
    END as segmento_monetary,
    CONCAT(
        CASE WHEN ultima_actividad >= '2018-10' THEN 'R' WHEN ultima_actividad >= '2018-07' THEN 'M' ELSE 'A' END,
        CASE WHEN total_vuelos >= 50 THEN 'A' WHEN total_vuelos >= 20 THEN 'M' ELSE 'B' END,
        CASE WHEN clv >= 10000 THEN 'A' WHEN clv >= 5000 THEN 'M' ELSE 'B' END
    ) as segmento_rfm_combinado
FROM customer_metrics
ORDER BY clv DESC
LIMIT 50;

-- ============================================================================
-- SECCIÓN BONUS: OPTIMIZACIÓN (10 puntos extra)
-- ============================================================================

-- EJERCICIO BONUS.1 (5 puntos)
-- ANÁLISIS DEL PLAN:
/*
El plan de ejecución probablemente muestra:
1. Full table scan en customer_loyalty_history
2. Full table scan en customer_flight_activity
3. Hash join o nested loop join
4. Filesort para el ORDER BY

Problemas identificados:
- Sin índice en province
- Sin índice en year
- Sin índice en cancellation_year
- El GROUP BY y ORDER BY pueden causar filesort
*/

-- PROPUESTA DE OPTIMIZACIÓN:
-- Crear índices compuestos para mejorar el rendimiento

CREATE INDEX idx_province_cancellation ON customer_loyalty_history(province, cancellation_year);
CREATE INDEX idx_year_loyalty ON customer_flight_activity(year, loyalty_number);
CREATE INDEX idx_loyalty_year ON customer_flight_activity(loyalty_number, year);

-- Consulta optimizada (alternativa):
SELECT 
    clh.loyalty_number,
    clh.province,
    clh.clv,
    SUM(cfa.total_flights) as total_vuelos
FROM customer_loyalty_history clh
FORCE INDEX (idx_province_cancellation)
JOIN customer_flight_activity cfa FORCE INDEX (idx_year_loyalty)
    ON clh.loyalty_number = cfa.loyalty_number
WHERE clh.province = 'Ontario'
    AND clh.cancellation_year IS NULL
    AND cfa.year = 2018
GROUP BY clh.loyalty_number, clh.province, clh.clv
HAVING total_vuelos > 10
ORDER BY total_vuelos DESC;

-- EJERCICIO BONUS.2 (5 puntos)
-- Índices recomendados para optimizar consultas comunes:

-- 1. Índice para búsquedas por provincia y estado de cancelación
CREATE INDEX idx_province_cancellation ON customer_loyalty_history(province, cancellation_year);
-- Justificación: Muchas consultas filtran por provincia y estado activo

-- 2. Índice para búsquedas por nivel de tarjeta
CREATE INDEX idx_loyalty_card_clv ON customer_loyalty_history(loyalty_card, clv DESC);
-- Justificación: Análisis de segmentación por tarjeta y ordenamiento por CLV

-- 3. Índice compuesto para actividad por año y mes
CREATE INDEX idx_year_month_loyalty ON customer_flight_activity(year, month, loyalty_number);
-- Justificación: Consultas temporales frecuentes

-- 4. Índice para análisis de puntos
CREATE INDEX idx_points ON customer_flight_activity(loyalty_number, points_accumulated, points_redeemed);
-- Justificación: Análisis de acumulación y canje de puntos

-- 5. Índice para búsquedas por inscripción
CREATE INDEX idx_enrollment ON customer_loyalty_history(enrollment_year, enrollment_type);
-- Justificación: Análisis de cohortes y comparación de programas

-- Verificar el impacto de los índices
SHOW INDEX FROM customer_loyalty_history;
SHOW INDEX FROM customer_flight_activity;

-- ============================================================================
-- NOTAS PARA EL INSTRUCTOR
-- ============================================================================
/*
CRITERIOS DE EVALUACIÓN:

1. Corrección (60%):
   - La consulta retorna los resultados correctos
   - La lógica de negocio es apropiada
   - No hay errores de sintaxis

2. Eficiencia (20%):
   - Uso apropiado de índices
   - Evita operaciones innecesarias
   - Consultas optimizadas

3. Estilo y Documentación (20%):
   - Código bien formateado
   - Comentarios apropiados
   - Nombres de columnas descriptivos

PUNTOS COMUNES DE ERROR:
- No usar NULLIF para evitar división por cero
- Olvidar filtrar clientes cancelados cuando se requiere
- No usar ROUND para valores monetarios
- Confundir HAVING con WHERE
- No considerar valores NULL en agregaciones

VARIACIONES ACEPTABLES:
- Uso de subconsultas vs JOINs (si el resultado es correcto)
- Diferentes nombres de alias
- Orden diferente de columnas (si se especifican todas)
*/

SELECT 'Soluciones del examen cargadas' AS mensaje;
