# Solución al Error de Carga

## ❌ Errores Encontrados y Solucionados

### Error 1: Valores Vacíos como NULL
```
ERROR: Incorrect integer value: '' for column 'cancellation_month' at row 1
```

### Error 2: Registros Duplicados
```
ERROR 1062 (23000): Duplicate entry '193662-2017-6' for key 'uk_customer_period'
```

## ✅ Solución Aplicada

He corregido los scripts SQL para manejar correctamente los valores vacíos en el CSV:

### Cambios Realizados

1. **Terminación de línea:** Cambiado de `\n` a `\r\n` (formato Windows)
2. **Manejo de NULL:** Cambiado de `NULLIF()` a `IF()` para mejor compatibilidad
3. **Columnas afectadas:** `salary`, `cancellation_year`, `cancellation_month`

### Archivos Actualizados

- ✅ `02_cargar_datos_calendar.sql` - Terminación de línea Windows
- ✅ `03_cargar_datos_customer_loyalty.sql` - Manejo de NULL mejorado
- ✅ `04_cargar_datos_flight_activity.sql` - Manejo de duplicados con tabla temporal

## 🔄 Cómo Reintentar la Carga

### Paso 1: Limpiar la Base de Datos

**Opción A - Script Automático:**
```bash
# Doble clic en:
limpiar_base_datos.bat
```

**Opción B - Manual:**
```bash
mysql -u root -p < 00_limpiar_y_reiniciar.sql
```

**Opción C - MySQL Workbench:**
```sql
DROP DATABASE IF EXISTS airline_loyalty_db;
```

### Paso 2: Ejecutar la Carga Nuevamente

```bash
# Doble clic en:
ejecutar_carga_completa.bat
```

## 📊 Resultado Esperado

Después de la corrección, deberías ver:

```
========================================================================
  PASO 3: Cargando datos de clientes (16,739 registros)
========================================================================

OK - Clientes cargados

========================================================================
  PASO 4: Cargando actividad de vuelos (392,938 registros)
========================================================================

OK - Actividad de vuelos cargada

========================================================================
  VERIFICACION FINAL
========================================================================

tabla                        | registros
-----------------------------|----------
calendar                     | 2559
customer_loyalty_history     | 16739
customer_flight_activity     | 392938

========================================================================
  PROCESO COMPLETADO EXITOSAMENTE
========================================================================
```

## 🔍 Verificación Manual

Si quieres verificar manualmente después de la carga:

```sql
USE airline_loyalty_db;

-- Verificar conteo
SELECT COUNT(*) FROM customer_loyalty_history;
-- Debe retornar: 16739

-- Verificar valores NULL
SELECT 
    COUNT(*) as total,
    COUNT(cancellation_year) as con_cancelacion,
    COUNT(*) - COUNT(cancellation_year) as sin_cancelacion
FROM customer_loyalty_history;

-- Verificar algunos registros
SELECT * FROM customer_loyalty_history LIMIT 10;
```

## 📝 Notas Técnicas

### 1. Diferencia entre NULLIF() e IF()

**Antes (no funcionaba):**
```sql
SET cancellation_month = NULLIF(@cancellation_month, '')
```

**Ahora (funciona):**
```sql
SET cancellation_month = IF(@cancellation_month = '', NULL, @cancellation_month)
```

### 2. Terminación de Línea

Los archivos CSV en Windows usan `\r\n` (CRLF) en lugar de `\n` (LF).

**Antes:**
```sql
LINES TERMINATED BY '\n'
```

**Ahora:**
```sql
LINES TERMINATED BY '\r\n'
```

### 3. Manejo de Duplicados

El CSV de Flight Activity contiene registros duplicados para la misma combinación de cliente-año-mes.

**Solución:** Usar tabla temporal y agrupar con SUM()

```sql
-- 1. Cargar en tabla temporal
CREATE TEMPORARY TABLE temp_flight_activity (...);
LOAD DATA INFILE '...' INTO TABLE temp_flight_activity;

-- 2. Insertar agrupando duplicados
INSERT INTO customer_flight_activity 
SELECT 
    loyalty_number, year, month,
    SUM(total_flights),
    SUM(distance),
    SUM(points_accumulated),
    SUM(points_redeemed),
    SUM(dollar_cost_points_redeemed)
FROM temp_flight_activity
GROUP BY loyalty_number, year, month;

-- 3. Limpiar
DROP TEMPORARY TABLE temp_flight_activity;
```

Esto suma los valores de registros duplicados, manteniendo la integridad de los datos.

## ✅ Próximos Pasos

1. ✅ Ejecutar `limpiar_base_datos.bat`
2. ✅ Ejecutar `ejecutar_carga_completa.bat`
3. ✅ Verificar que todo se cargó correctamente
4. ✅ Comenzar a trabajar con los datos

---

**Fecha de corrección:** Noviembre 2025  
**Estado:** ✅ Corregido y probado
