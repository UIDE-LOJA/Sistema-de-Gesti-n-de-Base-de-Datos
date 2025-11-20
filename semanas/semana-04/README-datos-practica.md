# Datos de Práctica - Semana 4: Optimización de Consultas

## Descripción General

Este script genera **~10,000 transacciones** adicionales para la práctica PE-1.4, permitiendo observar diferencias significativas en los planes de ejecución EXPLAIN.

## Propósito

Los datos originales de Semana 2 (~20 transacciones) son insuficientes para:
- Ver diferencias dramáticas entre `type=ALL` vs `type=range/ref`
- Analizar el impacto real de crear/eliminar índices
- Observar "Using temporary" y "Using filesort" en agregaciones

## Contenido del Script

### 1. **Comercios Adicionales (20 nuevos)**
- **Quito**: 5 comercios (Santa María, Fybeca, Petroecuador, etc.)
- **Guayaquil**: 5 comercios (Mi Comisariato, Metrovía, etc.)
- **Cuenca**: 5 comercios (Supermaxi, Mobil, TIA, etc.)
- **Otras ciudades**: 5 comercios (Ambato, Manta, Riobamba, Ibarra, Machala)

Total: **30 comercios activos** en Ecuador

### 2. **Transacciones Masivas (~10,000)**
- **Período**: Septiembre 2024 - Febrero 2025 (6 meses)
- **Distribución**:
  - 95% CONFIRMADO
  - 3% FALLIDO
  - 2% REVERTIDO
- **Montos**:
  - 70% transacciones pequeñas ($0.35 - $10.00)
  - 30% transacciones mayores ($10.00 - $50.00)
- **Horarios**: 06:00 - 22:00 (patrón realista)

## Instrucciones de Uso

### Paso 1: Verificar Base de Datos
```sql
USE pagos_qr_sistema;

-- Verificar datos actuales
SELECT COUNT(*) FROM Pagos_QR;  -- Debería tener ~20-25 registros
SELECT COUNT(*) FROM Comercios; -- Debería tener 10 comercios
```

### Paso 2: Ejecutar Script
```sql
SOURCE d:/UIDE/05 LTI_05A_300-SGBD-ASC/semanas/semana-04/02_datos_masivos_generados.sql;
```

O copiar y pegar el contenido completo en MySQL Workbench.

### Paso 3: Verificar Generación
```sql
-- Verificar total de transacciones
SELECT COUNT(*) FROM Pagos_QR;  -- Debería tener ~10,000+ registros

-- Ver distribución temporal
SELECT DATE_FORMAT(fecha, '%Y-%m') AS mes, COUNT(*) AS total
FROM Pagos_QR
GROUP BY mes
ORDER BY mes;
```

## Consultas Sugeridas para PE-1.4

### Consulta 1: SELECT Simple
```sql
-- SIN índice en monto (observar type=ALL)
EXPLAIN SELECT payment_id, cliente_id, monto, estado
FROM Pagos_QR
WHERE monto > 25.00;

-- CREAR índice
CREATE INDEX idx_monto ON Pagos_QR(monto);

-- CON índice (observar type=range)
EXPLAIN SELECT payment_id, cliente_id, monto, estado
FROM Pagos_QR
WHERE monto > 25.00;

-- ELIMINAR índice al terminar
DROP INDEX idx_monto ON Pagos_QR;
```

### Consulta 2: JOIN
```sql
-- Analizar uso de índices FK existentes
EXPLAIN SELECT
    p.payment_id,
    c.titular AS cliente,
    co.nombre AS comercio,
    p.monto,
    p.fecha
FROM Pagos_QR p
JOIN Cuentas c ON p.cliente_id = c.id
JOIN Comercios co ON p.comercio_id = co.id
WHERE p.fecha >= '2024-12-01'
  AND p.estado = 'CONFIRMADO';
```

### Consulta 3: Agregación
```sql
-- Observar "Using temporary" y "Using filesort"
EXPLAIN SELECT
    comercio_id,
    COUNT(*) AS num_transacciones,
    SUM(monto) AS total_ventas,
    AVG(monto) AS promedio
FROM Pagos_QR
WHERE estado = 'CONFIRMADO'
  AND fecha >= '2024-11-01'
GROUP BY comercio_id
ORDER BY total_ventas DESC;
```

## Métricas a Observar

### Antes de Crear Índices
- `type: ALL` → Escaneo completo de tabla
- `rows: ~10000` → Todas las filas examinadas
- `Extra: Using where; Using temporary; Using filesort`

### Después de Crear Índices
- `type: range/ref` → Uso de índice
- `rows: <1000` → Filas reducidas significativamente
- `Extra: Using index condition` → Índice usado efectivamente

## Notas Importantes

1. **Tiempo de Ejecución**: La carga de ~10,000 registros toma aproximadamente 30-60 segundos.

2. **ANALYZE TABLE**: El script ejecuta automáticamente `ANALYZE TABLE` para actualizar estadísticas.

3. **Idempotencia**: El script usa `INSERT IGNORE` para evitar duplicados si se ejecuta múltiples veces.

4. **Verificación**: Al final del script se ejecutan consultas automáticas de verificación que muestran:
   - Total de transacciones
   - Distribución por estado
   - Distribución temporal (por mes)

5. **Limpieza**: Si necesitas resetear los datos:
   ```sql
   -- CUIDADO: Esto elimina TODAS las transacciones generadas
   DELETE FROM Pagos_QR WHERE payment_id LIKE 'PAY_2024%' OR payment_id LIKE 'PAY_2025%';
   ```

## Estadísticas Esperadas

Después de ejecutar el script:

| Tabla | Registros Esperados |
|-------|---------------------|
| Cuentas | 48 (28 clientes + 20 comercios nuevos) |
| Comercios | 30 |
| Pagos_QR | ~10,020 |

## Relación con PE-1.4

Este volumen de datos permite:

- **Consulta 1 (SELECT simple)**: Ver diferencia clara entre type=ALL y type=range

- **Consulta 2 (JOIN)**: Analizar rendimiento con volumen real

- **Consulta 3 (Agregación)**: Observar "Using temporary" con datos significativos

- **Análisis comparativo**: Crear tabla con métricas antes/después realmente contrastantes

## Solución de Problemas

### Problema: Error de sintaxis al ejecutar
```sql
-- Asegúrate de estar usando MySQL 8.0
SELECT VERSION();
```

### Problema: Estadísticas no actualizadas
```sql
ANALYZE TABLE Pagos_QR;
ANALYZE TABLE Cuentas;
ANALYZE TABLE Comercios;
```

### Problema: Duplicados en comercios
El script usa `INSERT IGNORE` por lo que esto no debería ocurrir, pero si sucede:
```sql
-- Verificar duplicados
SELECT nombre, COUNT(*) FROM Comercios GROUP BY nombre HAVING COUNT(*) > 1;
```

## Contexto Ecuatoriano

Los datos incluyen comercios reales de Ecuador:
- Quito: Juan Valdez, Fybeca, Petroecuador
- Guayaquil: Mi Comisariato, Metrovía
- Cuenca: Supermaxi, TIA
- Otras: Ambato, Manta, Riobamba, Ibarra, Machala

Esto hace la práctica más realista y contextualizada para estudiantes ecuatorianos.
