-- ============================================================================
-- EJERCICIOS DE EXAMEN PRÁCTICO - Programa de Lealtad de Aerolínea
-- CURSO: Sistemas de Gestión de Bases de Datos (SGBD-ASC)
-- SEMANA: 05
-- DESCRIPCIÓN: Ejercicios prácticos para evaluación de conocimientos SQL
-- TIEMPO ESTIMADO: 90-120 minutos
-- ============================================================================

USE airline_loyalty_db;

-- ============================================================================
-- INSTRUCCIONES PARA EL ESTUDIANTE
-- ============================================================================
-- 1. Lea cuidadosamente cada ejercicio antes de comenzar
-- 2. Escriba su consulta SQL debajo de cada ejercicio
-- 3. Verifique que su consulta retorna los resultados esperados
-- 4. Optimice sus consultas usando índices cuando sea apropiado
-- 5. Documente su código con comentarios cuando sea necesario
-- ============================================================================

-- ============================================================================
-- SECCIÓN 1: CONSULTAS BÁSICAS (20 puntos)
-- ============================================================================

-- EJERCICIO 1.1 (5 puntos)
-- Listar todos los clientes de la provincia de Ontario que tienen tarjeta Aurora
-- Mostrar: loyalty_number, city, clv, enrollment_year
-- Ordenar por CLV descendente

-- TU RESPUESTA AQUÍ:



-- EJERCICIO 1.2 (5 puntos)
-- Contar cuántos clientes hay por cada nivel de educación
-- Mostrar: education, cantidad de clientes
-- Ordenar por cantidad descendente

-- TU RESPUESTA AQUÍ:



-- EJERCICIO 1.3 (5 puntos)
-- Encontrar el CLV promedio, mínimo y máximo por provincia
-- Mostrar: province, clv_promedio, clv_minimo, clv_maximo
-- Solo incluir provincias con más de 100 clientes

-- TU RESPUESTA AQUÍ:



-- EJERCICIO 1.4 (5 puntos)
-- Listar los 10 clientes que más puntos han acumulado en total
-- Mostrar: loyalty_number, loyalty_card, total_puntos_acumulados
-- Ordenar por puntos descendente

-- TU RESPUESTA AQUÍ:



-- ============================================================================
-- SECCIÓN 2: JOINS Y RELACIONES (25 puntos)
-- ============================================================================

-- EJERCICIO 2.1 (8 puntos)
-- Para cada cliente, mostrar su información demográfica junto con
-- el total de vuelos realizados y la distancia total recorrida
-- Mostrar: loyalty_number, nombre_completo (ciudad, provincia), 
--          loyalty_card, total_vuelos, distancia_total_km
-- Solo incluir clientes que hayan volado al menos una vez
-- Ordenar por distancia_total_km descendente
-- Limitar a los top 20

-- TU RESPUESTA AQUÍ:



-- EJERCICIO 2.2 (8 puntos)
-- Crear un reporte mensual de actividad para el año 2018
-- Mostrar: mes, clientes_activos, total_vuelos, distancia_promedio,
--          puntos_acumulados, puntos_canjeados, tasa_canje_porcentaje
-- Ordenar por mes

-- TU RESPUESTA AQUÍ:



-- EJERCICIO 2.3 (9 puntos)
-- Identificar clientes que se inscribieron en 2018 (Promoción 2018)
-- y compararlos con clientes Standard del mismo año
-- Mostrar: enrollment_type, cantidad_clientes, clv_promedio,
--          vuelos_promedio, puntos_promedio
-- Incluir solo datos de 2018

-- TU RESPUESTA AQUÍ:



-- ============================================================================
-- SECCIÓN 3: SUBCONSULTAS Y AGREGACIONES (25 puntos)
-- ============================================================================

-- EJERCICIO 3.1 (8 puntos)
-- Encontrar clientes cuyo CLV está por encima del promedio de su provincia
-- Mostrar: loyalty_number, province, clv, clv_promedio_provincia,
--          diferencia_vs_promedio
-- Ordenar por diferencia descendente
-- Limitar a top 30

-- TU RESPUESTA AQUÍ:



-- EJERCICIO 3.2 (9 puntos)
-- Identificar el mes con mayor actividad de vuelos para cada cliente
-- Mostrar: loyalty_number, loyalty_card, año, mes, total_vuelos_ese_mes,
--          total_vuelos_historico
-- Solo incluir clientes con más de 20 vuelos históricos
-- Ordenar por total_vuelos_ese_mes descendente
-- Limitar a top 25

-- TU RESPUESTA AQUÍ:



-- EJERCICIO 3.3 (8 puntos)
-- Calcular la tasa de retención por cohorte de inscripción
-- Mostrar: enrollment_year, total_inscritos, clientes_activos,
--          clientes_cancelados, tasa_retencion_porcentaje
-- Ordenar por año de inscripción

-- TU RESPUESTA AQUÍ:



-- ============================================================================
-- SECCIÓN 4: WINDOW FUNCTIONS Y CTEs (20 puntos)
-- ============================================================================

-- EJERCICIO 4.1 (10 puntos)
-- Usar Window Functions para rankear clientes por CLV dentro de cada provincia
-- Mostrar: loyalty_number, province, city, loyalty_card, clv,
--          ranking_en_provincia, percentil_en_provincia
-- Solo mostrar el top 3 de cada provincia
-- Ordenar por province, ranking

-- TU RESPUESTA AQUÍ:



-- EJERCICIO 4.2 (10 puntos)
-- Usar CTE para calcular el crecimiento mensual de actividad en 2018
-- Mostrar: mes, total_vuelos, vuelos_mes_anterior, 
--          crecimiento_absoluto, crecimiento_porcentual
-- Ordenar por mes

-- TU RESPUESTA AQUÍ:



-- ============================================================================
-- SECCIÓN 5: ANÁLISIS DE NEGOCIO (10 puntos)
-- ============================================================================

-- EJERCICIO 5.1 (10 puntos)
-- Crear un análisis RFM simplificado (Recency, Frequency, Monetary)
-- Clasificar clientes en segmentos:
-- - Recency: Última actividad (Reciente: 2018-10+, Medio: 2018-07+, Antiguo: resto)
-- - Frequency: Total vuelos (Alto: 50+, Medio: 20+, Bajo: resto)
-- - Monetary: CLV (Alto: 10000+, Medio: 5000+, Bajo: resto)
-- 
-- Mostrar: loyalty_number, loyalty_card, ultima_actividad,
--          total_vuelos, clv, segmento_recency, segmento_frequency,
--          segmento_monetary, segmento_rfm_combinado
-- Solo clientes activos (no cancelados)
-- Ordenar por CLV descendente
-- Limitar a top 50

-- TU RESPUESTA AQUÍ:



-- ============================================================================
-- SECCIÓN BONUS: OPTIMIZACIÓN (10 puntos extra)
-- ============================================================================

-- EJERCICIO BONUS.1 (5 puntos)
-- Analizar el plan de ejecución de la siguiente consulta y proponer mejoras:

EXPLAIN ANALYZE
SELECT 
    clh.loyalty_number,
    clh.province,
    clh.clv,
    SUM(cfa.total_flights) as total_vuelos
FROM customer_loyalty_history clh
JOIN customer_flight_activity cfa ON clh.loyalty_number = cfa.loyalty_number
WHERE clh.province = 'Ontario'
    AND cfa.year = 2018
    AND clh.cancellation_year IS NULL
GROUP BY clh.loyalty_number, clh.province, clh.clv
HAVING SUM(cfa.total_flights) > 10
ORDER BY total_vuelos DESC;

-- ANÁLISIS DEL PLAN:
-- (Escribe aquí tu análisis del plan de ejecución)



-- PROPUESTA DE OPTIMIZACIÓN:
-- (Escribe aquí tus propuestas de índices o reescritura de consulta)



-- EJERCICIO BONUS.2 (5 puntos)
-- Crear índices apropiados para optimizar las consultas más comunes
-- Justificar cada índice creado

-- TUS ÍNDICES AQUÍ:



-- ============================================================================
-- RÚBRICA DE EVALUACIÓN
-- ============================================================================
-- Sección 1: Consultas Básicas (20 puntos)
--   - Sintaxis correcta y resultados precisos
--   - Uso apropiado de WHERE, GROUP BY, ORDER BY
--
-- Sección 2: JOINs y Relaciones (25 puntos)
--   - Uso correcto de INNER JOIN, LEFT JOIN
--   - Agregaciones complejas
--   - Filtrado apropiado
--
-- Sección 3: Subconsultas y Agregaciones (25 puntos)
--   - Subconsultas correlacionadas y no correlacionadas
--   - Uso de HAVING
--   - Cálculos complejos
--
-- Sección 4: Window Functions y CTEs (20 puntos)
--   - Uso correcto de RANK, ROW_NUMBER, PARTITION BY
--   - CTEs bien estructurados
--   - Consultas recursivas (si aplica)
--
-- Sección 5: Análisis de Negocio (10 puntos)
--   - Lógica de negocio correcta
--   - Segmentación apropiada
--   - Interpretación de resultados
--
-- Bonus: Optimización (10 puntos extra)
--   - Análisis correcto del plan de ejecución
--   - Propuestas de optimización válidas
--   - Índices apropiados
--
-- TOTAL: 100 puntos (110 con bonus)
-- ============================================================================

-- ============================================================================
-- CRITERIOS DE CALIFICACIÓN
-- ============================================================================
-- Excelente (90-100): Todas las consultas correctas, optimizadas y bien documentadas
-- Muy Bueno (80-89): Mayoría de consultas correctas con optimización básica
-- Bueno (70-79): Consultas funcionales pero con oportunidades de mejora
-- Suficiente (60-69): Consultas básicas correctas, fallos en consultas avanzadas
-- Insuficiente (<60): Errores significativos o consultas incompletas
-- ============================================================================

SELECT 'Examen práctico cargado. ¡Buena suerte!' AS mensaje;
