# Guía para el Instructor - Semana 05

## Resumen del Material

Este paquete contiene un dataset completo del **Programa de Lealtad de Aerolínea Canadiense** con todos los scripts necesarios para:

1. Cargar los datos en MySQL
2. Realizar análisis avanzados
3. Evaluar a los estudiantes mediante examen práctico

## Contenido del Paquete

### Archivos de Datos (CSV)
- **Calendar.csv**: 2,559 registros (2012-2018)
- **Customer Loyalty History.csv**: 16,739 clientes
- **Customer Flight Activity.csv**: 392,938 registros de actividad

### Scripts SQL (9 archivos)

1. **00_ejecutar_todo.sql** - Script maestro que ejecuta todo
2. **01_crear_base_datos_airline_loyalty.sql** - Creación de BD y tablas
3. **02_cargar_datos_calendar.sql** - Carga de calendario
4. **03_cargar_datos_customer_loyalty.sql** - Carga de clientes
5. **04_cargar_datos_flight_activity.sql** - Carga de actividad
6. **05_consultas_analisis_avanzado.sql** - Consultas de ejemplo
7. **08_ejercicios_examen_practico.sql** - Examen para estudiantes
8. **09_soluciones_examen_practico.sql** - Soluciones (confidencial)

### Scripts Python (2 archivos)

- **06_cargar_datos_python.py** - Carga alternativa con Python
- **07_dividir_csv_grande.py** - Dividir CSVs grandes

### Documentación (3 archivos)

- **README.md** - Documentación del dataset
- **INSTRUCCIONES_CARGA_MYSQL.md** - Guía de instalación
- **GUIA_INSTRUCTOR.md** - Este archivo

## Preparación del Entorno

### Opción 1: Preparación Rápida (Recomendada)

```bash
# 1. Colocar los archivos CSV en una ubicación accesible
# 2. Ajustar las rutas en los scripts 02, 03 y 04
# 3. Ejecutar el script maestro
mysql -u root -p < 00_ejecutar_todo.sql
```

### Opción 2: Preparación Manual

```sql
-- 1. Crear la base de datos
SOURCE 01_crear_base_datos_airline_loyalty.sql;

-- 2. Cargar cada tabla individualmente
SOURCE 02_cargar_datos_calendar.sql;
SOURCE 03_cargar_datos_customer_loyalty.sql;
SOURCE 04_cargar_datos_flight_activity.sql;
```

### Opción 3: Usando Python

```bash
# Instalar dependencias
pip install mysql-connector-python pandas

# Configurar credenciales en el script
# Ejecutar
python 06_cargar_datos_python.py
```

## Verificación de la Instalación

Ejecutar las siguientes consultas para verificar:

```sql
USE airline_loyalty_db;

-- Verificar conteo de registros
SELECT 'calendar' as tabla, COUNT(*) as registros FROM calendar
UNION ALL
SELECT 'customer_loyalty_history', COUNT(*) FROM customer_loyalty_history
UNION ALL
SELECT 'customer_flight_activity', COUNT(*) FROM customer_flight_activity;

-- Resultado esperado:
-- calendar: 2,559
-- customer_loyalty_history: 16,739
-- customer_flight_activity: 392,938
```

## Uso en Clase

### Semana 05: Introducción y Exploración

**Objetivos:**
- Familiarizar a los estudiantes con el dataset
- Practicar consultas SQL básicas
- Introducir conceptos de análisis de datos

**Actividades Sugeridas:**
1. Exploración del esquema de la base de datos
2. Consultas SELECT básicas
3. Agregaciones simples (COUNT, SUM, AVG)
4. Introducción a JOINs

**Tiempo Estimado:** 2-3 horas

### Semanas 06-07: Análisis Avanzado

**Objetivos:**
- Consultas complejas con múltiples JOINs
- Subconsultas y CTEs
- Window Functions
- Optimización de consultas

**Actividades Sugeridas:**
1. Análisis de segmentación RFM
2. Análisis de cohortes
3. Patrones temporales
4. Optimización con índices

**Tiempo Estimado:** 4-6 horas

### Semana 08: Examen Práctico

**Formato del Examen:**
- Archivo: `08_ejercicios_examen_practico.sql`
- Duración: 90-120 minutos
- Puntuación: 100 puntos (110 con bonus)
- Modalidad: Individual, libro abierto

**Estructura:**
1. Consultas Básicas (20 pts)
2. JOINs y Relaciones (25 pts)
3. Subconsultas y Agregaciones (25 pts)
4. Window Functions y CTEs (20 pts)
5. Análisis de Negocio (10 pts)
6. Bonus: Optimización (10 pts extra)

## Evaluación del Examen

### Criterios de Calificación

**Corrección (60%)**
- Resultados correctos
- Lógica de negocio apropiada
- Sin errores de sintaxis

**Eficiencia (20%)**
- Uso apropiado de índices
- Consultas optimizadas
- Evita operaciones innecesarias

**Estilo y Documentación (20%)**
- Código bien formateado
- Comentarios apropiados
- Nombres descriptivos

### Escala de Calificación

- **Excelente (90-100)**: Todas las consultas correctas, optimizadas y documentadas
- **Muy Bueno (80-89)**: Mayoría correctas con optimización básica
- **Bueno (70-79)**: Consultas funcionales con oportunidades de mejora
- **Suficiente (60-69)**: Consultas básicas correctas, fallos en avanzadas
- **Insuficiente (<60)**: Errores significativos o incompletas

### Puntos Comunes de Error

1. **División por cero**: No usar NULLIF
2. **Valores NULL**: No considerar en agregaciones
3. **Filtros incorrectos**: Confundir WHERE con HAVING
4. **Clientes cancelados**: Olvidar filtrar cuando se requiere
5. **Formato de resultados**: No usar ROUND para valores monetarios

## Consultas de Ejemplo para Demostración

### Ejemplo 1: Análisis Básico
```sql
-- Top 10 clientes por CLV
SELECT 
    loyalty_number,
    loyalty_card,
    province,
    clv
FROM customer_loyalty_history
WHERE cancellation_year IS NULL
ORDER BY clv DESC
LIMIT 10;
```

### Ejemplo 2: Análisis con JOIN
```sql
-- Actividad mensual agregada
SELECT 
    year,
    month,
    COUNT(DISTINCT loyalty_number) as clientes_activos,
    SUM(total_flights) as total_vuelos,
    ROUND(AVG(distance), 2) as distancia_promedio
FROM customer_flight_activity
WHERE year = 2018
GROUP BY year, month
ORDER BY month;
```

### Ejemplo 3: Window Function
```sql
-- Ranking de clientes por provincia
SELECT 
    loyalty_number,
    province,
    clv,
    RANK() OVER (PARTITION BY province ORDER BY clv DESC) as ranking
FROM customer_loyalty_history
WHERE cancellation_year IS NULL
QUALIFY ranking <= 5;
```

## Extensiones y Proyectos Adicionales

### Proyecto 1: Dashboard de Análisis
Crear un dashboard con métricas clave:
- KPIs del programa
- Tendencias temporales
- Segmentación de clientes
- Análisis geográfico

### Proyecto 2: Modelo Predictivo
Predecir cancelaciones usando:
- Características demográficas
- Patrones de actividad
- Uso de puntos
- Análisis de cohortes

### Proyecto 3: Optimización de Base de Datos
Optimizar el rendimiento:
- Diseño de índices
- Particionamiento de tablas
- Vistas materializadas
- Análisis de planes de ejecución

## Recursos Adicionales

### Documentación MySQL
- https://dev.mysql.com/doc/
- https://dev.mysql.com/doc/refman/8.0/en/optimization.html

### Tutoriales Recomendados
- Window Functions: https://dev.mysql.com/doc/refman/8.0/en/window-functions.html
- CTEs: https://dev.mysql.com/doc/refman/8.0/en/with.html
- Optimización: https://dev.mysql.com/doc/refman/8.0/en/optimization-indexes.html

### Herramientas Útiles
- MySQL Workbench: Interfaz gráfica
- DBeaver: Cliente universal de BD
- Explain Analyzer: Análisis de planes de ejecución

## Solución de Problemas Comunes

### Problema: "Loading local data is disabled"
**Solución:**
```sql
SET GLOBAL local_infile = 1;
```

### Problema: "The MySQL server is running with --secure-file-priv"
**Solución:**
- Verificar ruta: `SHOW VARIABLES LIKE 'secure_file_priv';`
- Mover archivos CSV a esa ubicación
- O usar el script Python alternativo

### Problema: Carga muy lenta
**Solución:**
```sql
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;
SET AUTOCOMMIT = 0;
-- Realizar carga
COMMIT;
SET FOREIGN_KEY_CHECKS = 1;
SET UNIQUE_CHECKS = 1;
SET AUTOCOMMIT = 1;
```

## Contacto y Soporte

Para preguntas o problemas:
- Revisar INSTRUCCIONES_CARGA_MYSQL.md
- Consultar documentación de MySQL
- Contactar al coordinador del curso

## Notas Finales

### Consideraciones Pedagógicas

1. **Progresión Gradual**: Comenzar con consultas simples y aumentar complejidad
2. **Práctica Guiada**: Demostrar ejemplos antes de ejercicios independientes
3. **Retroalimentación**: Proporcionar feedback constructivo en el examen
4. **Aplicación Real**: Enfatizar casos de uso del mundo real

### Actualizaciones Futuras

Para el siguiente ciclo (Mayo 2026):
- Considerar agregar más datos históricos (2019-2020)
- Incluir datos de COVID-19 para análisis de impacto
- Agregar dimensión de rutas de vuelo
- Incluir datos de competidores para análisis comparativo

### Licencia y Uso

Este material es para uso educativo exclusivamente en el curso:
**LTI_05A_300-SGBD-ASC - Sistemas de Gestión de Bases de Datos**

---

**Última actualización**: Noviembre 2025  
**Preparado por**: Curso SGBD-ASC  
**Versión**: 1.0
