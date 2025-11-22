-- ============================================================================
-- SCRIPT: Consultas de Análisis Avanzado - Programa de Lealtad
-- CURSO: Sistemas de Gestión de Bases de Datos (SGBD-ASC)
-- SEMANA: 05
-- DESCRIPCIÓN: Consultas SQL avanzadas para análisis del programa de lealtad
-- TEMAS: JOINs, Agregaciones, Subconsultas, Window Functions, CTEs
-- ============================================================================

USE airline_loyalty_db;

-- ============================================================================
-- SECCIÓN 1: ANÁLISIS DE SEGMENTACIÓN DE CLIENTES
-- ============================================================================

-- 1.1 Segmentación RFM (Recency, Frequency, Monetary)
SELECT 
    clh.loyalty_number,
    clh.loyalty_card,
    clh.province,
    MAX(CONCAT(cfa.year, '-', LPAD(cfa.month, 2, '0'))) as ultima_actividad,
    SUM(cfa.total_flights) as frecuencia_vuelos,
    clh.clv as valor_monetario,
    CASE 
        WHEN MAX(CONCAT(cfa.year, '-', LPAD(cfa.month, 2, '0'))) >= '2018-10' THEN 'Reciente'
        WHEN MAX(CONCAT(cfa.year, '-', LPAD(cfa.month, 2, '0'))) >= '2018-07' THEN 'Medio'
        ELSE 'Antiguo'
    END as recency_segment,
    CASE 
        WHEN SUM(cfa.total_flights) >= 50 THEN 'Alto'
        WHEN SUM(cfa.total_flights) >= 20 THEN 'Medio'
        ELSE 'Bajo'
    END as frequency_segment,
    CASE 
        WHEN clh.clv >= 10000 THEN 'Alto'
        WHEN clh.clv >= 5000 THEN 'Medio'
        ELSE 'Bajo'
    END as monetary_segment
FROM customer_loyalty_history clh
LEFT JOIN customer_flight_activity cfa ON clh.loyalty_number = cfa.loyalty_number
WHERE clh.cancellation_year IS NULL
GROUP BY clh.loyalty_number, clh.loyalty_card, clh.province, clh.clv
ORDER BY valor_monetario DESC
LIMIT 100;

-- 1.2 Análisis de cohortes por año de inscripción
SELECT 
    clh.enrollment_year,
    clh.loyalty_card,
    COUNT(DISTINCT clh.loyalty_number) as clientes_inscritos,
    COUNT(DISTINCT CASE WHEN clh.cancellation_year IS NULL THEN clh.loyalty_number END) as clientes_activos,
    ROUND(COUNT(DISTINCT CASE WHEN clh.cancellation_year IS NULL THEN clh.loyalty_number END) * 100.0 / 
          COUNT(DISTINCT clh.loyalty_number), 2) as tasa_retencion_pct,
    ROUND(AVG(clh.clv), 2) as clv_promedio,
    SUM(cfa.total_flights) as total_vuelos_cohorte
FROM customer_loyalty_history clh
LEFT JOIN customer_flight_activity cfa ON clh.loyalty_number = cfa.loyalty_number
GROUP BY clh.enrollment_year, clh.loyalty_card
ORDER BY clh.enrollment_year, clh.loyalty_card;

-- ============================================================================
-- SECCIÓN 2: ANÁLISIS DE COMPORTAMIENTO DE VUELO
-- ============================================================================

-- 2.1 Patrones estacionales de vuelo
SELECT 
    cfa.month as mes,
    COUNT(DISTINCT cfa.loyalty_number) as clientes_activos,
    SUM(cfa.total_flights) as total_vuelos,
    ROUND(AVG(cfa.distance), 2) as distancia_promedio_km,
    SUM(cfa.points_accumulated) as puntos_acumulados,
    ROUND(AVG(cfa.total_flights), 2) as vuelos_promedio_por_cliente
FROM customer_flight_activity cfa
WHERE cfa.year = 2018 AND cfa.total_flights > 0
GROUP BY cfa.month
ORDER BY cfa.month;

-- 2.2 Clientes con mayor crecimiento en actividad (2018 vs promedio anterior)
WITH actividad_2018 AS (
    SELECT 
        loyalty_number,
        SUM(total_flights) as vuelos_2018,
        SUM(distance) as distancia_2018
    FROM customer_flight_activity
    WHERE year = 2018
    GROUP BY loyalty_number
),
actividad_anterior AS (
    SELECT 
        loyalty_number,
        AVG(total_flights) as vuelos_promedio_anterior,
        AVG(distance) as distancia_promedio_anterior
    FROM customer_flight_activity
    WHERE year < 2018
    GROUP BY loyalty_number
)
SELECT 
    clh.loyalty_number,
    clh.loyalty_card,
    clh.province,
    a2018.vuelos_2018,
    ROUND(aant.vuelos_promedio_anterior, 2) as vuelos_promedio_anterior,
    ROUND((a2018.vuelos_2018 - aant.vuelos_promedio_anterior) / aant.vuelos_promedio_anterior * 100, 2) as crecimiento_pct
FROM customer_loyalty_history clh
JOIN actividad_2018 a2018 ON clh.loyalty_number = a2018.loyalty_number
JOIN actividad_anterior aant ON clh.loyalty_number = aant.loyalty_number
WHERE aant.vuelos_promedio_anterior > 0
ORDER BY crecimiento_pct DESC
LIMIT 20;

-- ============================================================================
-- SECCIÓN 3: ANÁLISIS DEL PROGRAMA DE PUNTOS
-- ============================================================================

-- 3.1 Tasa de canje de puntos por segmento
SELECT 
    clh.loyalty_card,
    COUNT(DISTINCT clh.loyalty_number) as total_clientes,
    SUM(cfa.points_accumulated) as puntos_acumulados,
    SUM(cfa.points_redeemed) as puntos_canjeados,
    ROUND(SUM(cfa.points_redeemed) * 100.0 / NULLIF(SUM(cfa.points_accumulated), 0), 2) as tasa_canje_pct,
    ROUND(SUM(cfa.dollar_cost_points_redeemed), 2) as valor_total_canjes_cad,
    ROUND(AVG(cfa.dollar_cost_points_redeemed), 2) as valor_promedio_canje_cad
FROM customer_loyalty_history clh
JOIN customer_flight_activity cfa ON clh.loyalty_number = cfa.loyalty_number
GROUP BY clh.loyalty_card
ORDER BY FIELD(clh.loyalty_card, 'Star', 'Nova', 'Aurora');

-- 3.2 Clientes que acumulan pero no canjean (oportunidad de engagement)
SELECT 
    clh.loyalty_number,
    clh.loyalty_card,
    clh.province,
    clh.education,
    SUM(cfa.points_accumulated) as puntos_acumulados,
    SUM(cfa.points_redeemed) as puntos_canjeados,
    SUM(cfa.points_accumulated) - SUM(cfa.points_redeemed) as saldo_puntos
FROM customer_loyalty_history clh
JOIN customer_flight_activity cfa ON clh.loyalty_number = cfa.loyalty_number
WHERE clh.cancellation_year IS NULL
GROUP BY clh.loyalty_number, clh.loyalty_card, clh.province, clh.education
HAVING SUM(cfa.points_accumulated) > 10000 
    AND SUM(cfa.points_redeemed) = 0
ORDER BY puntos_acumulados DESC
LIMIT 50;

-- 3.3 Análisis de valor de puntos por nivel de tarjeta
SELECT 
    clh.loyalty_card,
    COUNT(DISTINCT CASE WHEN cfa.points_redeemed > 0 THEN clh.loyalty_number END) as clientes_que_canjean,
    SUM(cfa.points_redeemed) as total_puntos_canjeados,
    SUM(cfa.dollar_cost_points_redeemed) as total_valor_cad,
    ROUND(SUM(cfa.dollar_cost_points_redeemed) / NULLIF(SUM(cfa.points_redeemed), 0), 4) as valor_por_punto_cad
FROM customer_loyalty_history clh
JOIN customer_flight_activity cfa ON clh.loyalty_number = cfa.loyalty_number
WHERE cfa.points_redeemed > 0
GROUP BY clh.loyalty_card
ORDER BY FIELD(clh.loyalty_card, 'Star', 'Nova', 'Aurora');

-- ============================================================================
-- SECCIÓN 4: ANÁLISIS DE RETENCIÓN Y CHURN
-- ============================================================================

-- 4.1 Análisis de cancelaciones por características demográficas
SELECT 
    loyalty_card,
    province,
    COUNT(*) as total_clientes,
    COUNT(CASE WHEN cancellation_year IS NOT NULL THEN 1 END) as clientes_cancelados,
    ROUND(COUNT(CASE WHEN cancellation_year IS NOT NULL THEN 1 END) * 100.0 / COUNT(*), 2) as tasa_cancelacion_pct,
    ROUND(AVG(CASE WHEN cancellation_year IS NOT NULL THEN clv END), 2) as clv_promedio_cancelados,
    ROUND(AVG(CASE WHEN cancellation_year IS NULL THEN clv END), 2) as clv_promedio_activos
FROM customer_loyalty_history
GROUP BY loyalty_card, province
HAVING COUNT(*) >= 10
ORDER BY tasa_cancelacion_pct DESC
LIMIT 20;

-- 4.2 Tiempo promedio de membresía antes de cancelación
SELECT 
    loyalty_card,
    COUNT(*) as clientes_cancelados,
    ROUND(AVG((cancellation_year - enrollment_year) * 12 + (cancellation_month - enrollment_month)), 2) as meses_promedio_membresia,
    MIN((cancellation_year - enrollment_year) * 12 + (cancellation_month - enrollment_month)) as min_meses,
    MAX((cancellation_year - enrollment_year) * 12 + (cancellation_month - enrollment_month)) as max_meses
FROM customer_loyalty_history
WHERE cancellation_year IS NOT NULL
GROUP BY loyalty_card
ORDER BY FIELD(loyalty_card, 'Star', 'Nova', 'Aurora');

-- 4.3 Clientes en riesgo (sin actividad reciente)
SELECT 
    clh.loyalty_number,
    clh.loyalty_card,
    clh.province,
    clh.clv,
    MAX(CONCAT(cfa.year, '-', LPAD(cfa.month, 2, '0'))) as ultima_actividad,
    TIMESTAMPDIFF(MONTH, 
        STR_TO_DATE(MAX(CONCAT(cfa.year, '-', LPAD(cfa.month, 2, '0'), '-01')), '%Y-%m-%d'),
        '2018-12-01') as meses_sin_actividad,
    SUM(cfa.points_accumulated) - SUM(cfa.points_redeemed) as saldo_puntos
FROM customer_loyalty_history clh
JOIN customer_flight_activity cfa ON clh.loyalty_number = cfa.loyalty_number
WHERE clh.cancellation_year IS NULL
GROUP BY clh.loyalty_number, clh.loyalty_card, clh.province, clh.clv
HAVING MAX(CONCAT(cfa.year, '-', LPAD(cfa.month, 2, '0'))) < '2018-09'
    AND clh.clv > 5000
ORDER BY clh.clv DESC
LIMIT 50;

-- ============================================================================
-- SECCIÓN 5: ANÁLISIS GEOGRÁFICO
-- ============================================================================

-- 5.1 Rendimiento por provincia
SELECT 
    clh.province,
    COUNT(DISTINCT clh.loyalty_number) as total_clientes,
    ROUND(AVG(clh.clv), 2) as clv_promedio,
    SUM(cfa.total_flights) as total_vuelos,
    ROUND(SUM(cfa.distance) / 1000, 2) as distancia_miles_km,
    ROUND(AVG(cfa.distance), 2) as distancia_promedio_km,
    SUM(cfa.points_accumulated) as puntos_acumulados
FROM customer_loyalty_history clh
LEFT JOIN customer_flight_activity cfa ON clh.loyalty_number = cfa.loyalty_number
GROUP BY clh.province
ORDER BY total_clientes DESC;

-- 5.2 Top ciudades por CLV promedio
SELECT 
    clh.province,
    clh.city,
    COUNT(DISTINCT clh.loyalty_number) as total_clientes,
    ROUND(AVG(clh.clv), 2) as clv_promedio,
    ROUND(AVG(clh.salary), 2) as salario_promedio,
    SUM(cfa.total_flights) as total_vuelos
FROM customer_loyalty_history clh
LEFT JOIN customer_flight_activity cfa ON clh.loyalty_number = cfa.loyalty_number
GROUP BY clh.province, clh.city
HAVING COUNT(DISTINCT clh.loyalty_number) >= 5
ORDER BY clv_promedio DESC
LIMIT 20;

-- ============================================================================
-- SECCIÓN 6: ANÁLISIS DE RENTABILIDAD
-- ============================================================================

-- 6.1 ROI del programa de lealtad por segmento
SELECT 
    clh.loyalty_card,
    COUNT(DISTINCT clh.loyalty_number) as total_clientes,
    ROUND(SUM(clh.clv), 2) as revenue_total,
    ROUND(SUM(cfa.dollar_cost_points_redeemed), 2) as costo_puntos_canjeados,
    ROUND(SUM(clh.clv) - SUM(cfa.dollar_cost_points_redeemed), 2) as beneficio_neto,
    ROUND((SUM(clh.clv) - SUM(cfa.dollar_cost_points_redeemed)) / NULLIF(SUM(cfa.dollar_cost_points_redeemed), 0) * 100, 2) as roi_pct
FROM customer_loyalty_history clh
LEFT JOIN customer_flight_activity cfa ON clh.loyalty_number = cfa.loyalty_number
GROUP BY clh.loyalty_card
ORDER BY FIELD(clh.loyalty_card, 'Star', 'Nova', 'Aurora');

-- 6.2 Comparación: Promoción 2018 vs Standard
SELECT 
    clh.enrollment_type,
    COUNT(DISTINCT clh.loyalty_number) as total_clientes,
    ROUND(AVG(clh.clv), 2) as clv_promedio,
    ROUND(AVG(cfa_agg.total_vuelos), 2) as vuelos_promedio,
    ROUND(AVG(cfa_agg.puntos_acumulados), 2) as puntos_promedio,
    ROUND(AVG(cfa_agg.puntos_canjeados), 2) as canjes_promedio
FROM customer_loyalty_history clh
LEFT JOIN (
    SELECT 
        loyalty_number,
        SUM(total_flights) as total_vuelos,
        SUM(points_accumulated) as puntos_acumulados,
        SUM(points_redeemed) as puntos_canjeados
    FROM customer_flight_activity
    GROUP BY loyalty_number
) cfa_agg ON clh.loyalty_number = cfa_agg.loyalty_number
GROUP BY clh.enrollment_type;

-- ============================================================================
-- SECCIÓN 7: ANÁLISIS CON WINDOW FUNCTIONS
-- ============================================================================

-- 7.1 Ranking de clientes por CLV dentro de cada provincia
SELECT 
    loyalty_number,
    province,
    city,
    loyalty_card,
    clv,
    RANK() OVER (PARTITION BY province ORDER BY clv DESC) as ranking_provincia,
    ROUND(clv / SUM(clv) OVER (PARTITION BY province) * 100, 2) as pct_clv_provincia
FROM customer_loyalty_history
WHERE cancellation_year IS NULL
QUALIFY ranking_provincia <= 5
ORDER BY province, ranking_provincia;

-- 7.2 Tendencia de actividad mensual por cliente (últimos 6 meses de 2018)
SELECT 
    loyalty_number,
    year,
    month,
    total_flights,
    distance,
    AVG(total_flights) OVER (
        PARTITION BY loyalty_number 
        ORDER BY year, month 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as vuelos_promedio_movil_3m,
    SUM(distance) OVER (
        PARTITION BY loyalty_number 
        ORDER BY year, month
    ) as distancia_acumulada
FROM customer_flight_activity
WHERE year = 2018 AND month >= 7
ORDER BY loyalty_number, year, month
LIMIT 100;

-- ============================================================================
-- FINALIZACIÓN
-- ============================================================================
SELECT 'Consultas de análisis avanzado completadas' AS status;
