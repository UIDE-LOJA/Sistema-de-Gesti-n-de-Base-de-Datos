# Semana 05 - Programa de Lealtad de Aerolínea (Airline Loyalty Program)

## Descripción General

Este conjunto de datos contiene información completa sobre un **Programa de Lealtad de una Aerolínea Canadiense**, diseñado para analizar el comportamiento de los clientes, sus patrones de vuelo y la efectividad del programa de fidelización.

## Estructura de Datos

El dataset está compuesto por **4 archivos CSV principales**:

### 1. **Airline Loyalty Data Dictionary** (Diccionario de Datos)
Documento de referencia que describe la estructura y significado de todos los campos en las tablas principales.

### 2. **Calendar.csv** (Calendario)
- **Período**: 2012-01-01 hasta 2018-12-31 (7 años)
- **Campos**:
  - `Date`: Fecha específica
  - `Start of Year`: Inicio del año
  - `Start of Quarter`: Inicio del trimestre
  - `Start of Month`: Inicio del mes
- **Propósito**: Tabla dimensional para análisis temporal y agregaciones por períodos

### 3. **Customer Flight Activity.csv** (Actividad de Vuelos)
Contiene **392,938 registros** de actividad mensual de vuelos por cliente.

#### Campos principales:
- `Loyalty Number`: Número único de lealtad del cliente
- `Year`: Año del período
- `Month`: Mes del período
- `Total Flights`: Total de vuelos reservados en el período
- `Distance`: Distancia de vuelo recorrida (km)
- `Points Accumulated`: Puntos de lealtad acumulados
- `Points Redeemed`: Puntos de lealtad canjeados
- `Dollar Cost Points Redeemed`: Valor en dólares canadienses de los puntos canjeados

#### Características importantes:
- Datos mensuales por cliente desde 2018
- Incluye meses sin actividad (valores en 0)
- Permite análisis de patrones de viaje y uso de puntos
- Rango de distancias: desde 0 hasta más de 65,000 km mensuales
- Algunos clientes acumulan más de 97,000 puntos en un mes

### 4. **Customer Loyalty History.csv** (Historial de Clientes)
Contiene **16,739 registros** de clientes únicos con su información demográfica y de membresía.

#### Campos principales:

**Información Demográfica:**
- `Loyalty Number`: Identificador único del cliente
- `Country`: País de residencia (Canadá)
- `Province`: Provincia de residencia
- `City`: Ciudad de residencia
- `Postal Code`: Código postal
- `Gender`: Género (Male/Female)
- `Education`: Nivel educativo (High School or Below, College, Bachelor, Master, Doctor)
- `Salary`: Ingreso anual
- `Marital Status`: Estado civil (Single, Married, Divorced)

**Información del Programa:**
- `Loyalty Card`: Nivel de tarjeta (Star, Nova, Aurora)
- `CLV` (Customer Lifetime Value): Valor total de todas las facturas de vuelos
- `Enrollment Type`: Tipo de inscripción (Standard, 2018 Promotion)
- `Enrollment Year`: Año de inscripción
- `Enrollment Month`: Mes de inscripción
- `Cancellation Year`: Año de cancelación (si aplica)
- `Cancellation Month`: Mes de cancelación (si aplica)

#### Características importantes:
- **Niveles de Tarjeta**: Star (básico), Nova (intermedio), Aurora (premium)
- **CLV**: Rango desde ~$2,790 hasta más de $245,000
- **Educación**: Desde secundaria hasta doctorado
- **Salarios**: Rango amplio, algunos campos vacíos
- **Cancelaciones**: Algunos clientes han cancelado su membresía
- **Promoción 2018**: Programa especial de inscripción

## Casos de Uso y Análisis Posibles

### 1. **Análisis de Segmentación de Clientes**
- Segmentar por nivel de tarjeta (Star, Nova, Aurora)
- Análisis demográfico (edad, educación, ubicación)
- Identificar clientes de alto valor (CLV)

### 2. **Análisis de Comportamiento de Vuelo**
- Patrones de viaje mensuales y estacionales
- Frecuencia de vuelos por segmento
- Distancias promedio recorridas

### 3. **Análisis del Programa de Puntos**
- Tasa de acumulación vs. canje de puntos
- Valor monetario de los puntos canjeados
- Identificar clientes que acumulan pero no canjean

### 4. **Análisis de Retención y Churn**
- Tasa de cancelación por segmento
- Tiempo promedio de membresía
- Factores asociados a la cancelación

### 5. **Análisis Geográfico**
- Distribución de clientes por provincia/ciudad
- Patrones de vuelo por región
- Oportunidades de mercado

### 6. **Análisis de Rentabilidad**
- CLV por segmento demográfico
- ROI del programa de lealtad
- Efectividad de la promoción 2018

## Insights Preliminares

- **Período de datos**: 2012-2018 (7 años completos)
- **Clientes activos**: 16,739 registros únicos
- **Registros de actividad**: 392,938 (incluye meses sin actividad)
- **Cobertura geográfica**: Todo Canadá (10 provincias + territorios)
- **Programa de promoción**: Lanzado en 2018 con tipo de inscripción especial

## Notas Importantes

1. **Datos de 2018**: La mayoría de la actividad de vuelos está concentrada en 2018
2. **Valores nulos**: Algunos campos de salario están vacíos
3. **Moneda**: Todos los valores monetarios están en dólares canadienses (CDN)
4. **Distancias**: Medidas en kilómetros
5. **Meses sin actividad**: Se registran con valores en 0 para mantener la continuidad temporal

## Aplicación Académica

Este dataset es ideal para:
- Prácticas de **modelado de bases de datos relacionales**
- Ejercicios de **consultas SQL complejas** (JOINs, agregaciones, subconsultas)
- Análisis de **Business Intelligence**
- Proyectos de **Data Mining y Machine Learning**
- Estudios de caso de **CRM y Marketing Analytics**

## Archivos del Proyecto

### 📁 Estructura de Archivos

```
semana-05/
├── ejecutar_carga_completa.bat          ⭐ EJECUTAR ESTE (Windows)
├── ejecutar_carga_completa.ps1          ⭐ O ESTE (PowerShell)
│
├── 01_crear_base_datos_airline_loyalty.sql
├── 02_cargar_datos_calendar.sql
├── 03_cargar_datos_customer_loyalty.sql
├── 04_cargar_datos_flight_activity.sql
│
├── 05_consultas_analisis_avanzado.sql   📊 Consultas de ejemplo
├── 06_cargar_datos_python.py            🐍 Alternativa Python
├── 07_dividir_csv_grande.py             🔧 Utilidad
│
├── 08_ejercicios_examen_practico.sql    📝 Examen (100 pts)
├── 09_soluciones_examen_practico.sql    🔒 Solo instructor
│
├── GUIA_INSTRUCTOR.md                   👨‍🏫 Guía pedagógica
└── README.md                            📖 Este archivo
```

### 🚀 Inicio Rápido

#### Paso 1: Verificar Archivos CSV

Los archivos CSV deben estar en:
```
C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\
```

Archivos requeridos:
- ✅ Calendar.csv
- ✅ Customer Loyalty History.csv
- ✅ Customer Flight Activity.csv

#### Paso 2: Ejecutar Carga

**Método 1 - Script Automático (RECOMENDADO):**
```bash
# Doble clic en:
ejecutar_carga_completa.bat
```

**Método 2 - MySQL Workbench:**
1. Abrir MySQL Workbench
2. Ejecutar cada script en orden (01, 02, 03, 04)

**Método 3 - Línea de Comandos:**
```bash
mysql -u root -p < 01_crear_base_datos_airline_loyalty.sql
mysql -u root -p airline_loyalty_db < 02_cargar_datos_calendar.sql
mysql -u root -p airline_loyalty_db < 03_cargar_datos_customer_loyalty.sql
mysql -u root -p airline_loyalty_db < 04_cargar_datos_flight_activity.sql
```

#### Paso 3: Verificar

```sql
USE airline_loyalty_db;

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

### 🔧 Características Técnicas

- **Motor:** InnoDB (transacciones ACID)
- **Charset:** utf8mb4 (Unicode completo)
- **Índices:** Optimizados para consultas comunes
- **Integridad:** Claves foráneas configuradas
- **Vistas:** 3 vistas predefinidas

**Vistas incluidas:**
1. `v_active_customers` - Clientes activos con métricas
2. `v_monthly_activity_summary` - Actividad mensual
3. `v_loyalty_card_segments` - Segmentación por tarjeta

**Tiempo de carga:** 5-10 minutos (412,236 registros totales)

## 📝 Uso como Examen Práctico

**Archivo:** `08_ejercicios_examen_practico.sql`

**Estructura del examen:**
- Consultas Básicas (20 pts)
- JOINs y Relaciones (25 pts)
- Subconsultas y Agregaciones (25 pts)
- Window Functions y CTEs (20 pts)
- Análisis de Negocio (10 pts)
- Bonus: Optimización (10 pts)

**Total:** 100 puntos (110 con bonus)  
**Duración:** 90-120 minutos

Ver `05_consultas_analisis_avanzado.sql` para ejemplos de consultas complejas.

## ❓ Solución de Problemas

### Error: "Incorrect integer value" o problemas con NULL
**Solución:** Los scripts ya están corregidos. Si el error persiste:
1. Ejecutar: `limpiar_base_datos.bat`
2. Reintentar: `ejecutar_carga_completa.bat`
3. Ver: `SOLUCION_ERROR.md` para más detalles

### Error: "Can't get stat of" o "File not found"
**Solución:** Verifica que los CSV estén en `C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\`

### Error: "Access denied"
**Solución:**
```sql
GRANT FILE ON *.* TO 'root'@'localhost';
FLUSH PRIVILEGES;
```

### Error: "secure-file-priv"
**Solución:**
```sql
SHOW VARIABLES LIKE 'secure_file_priv';
-- Mover los CSV a la ruta que muestre
```

### Reiniciar la Carga
Si necesitas empezar de nuevo:
```bash
# Doble clic en:
limpiar_base_datos.bat
# Luego ejecutar nuevamente:
ejecutar_carga_completa.bat
```

## Nota del Instructor

> **Para el siguiente ciclo de mayo**: Tomar en cuenta esta presentación para actualizar el contenido del curso.

---

**Última actualización**: Noviembre 2025  
**Asignatura**: LTI_05A_300-SGBD-ASC (Sistemas de Gestión de Bases de Datos)
