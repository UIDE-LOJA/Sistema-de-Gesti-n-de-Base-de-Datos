# 🎯 Práctica de Transacciones y Control de Concurrencia - MySQL Workbench

## 📋 Descripción
Scripts SQL para practicar conceptos de transacciones, propiedades ACID y control de concurrencia usando MySQL Workbench con el sistema de pagos QR "¡ahorita!" del Banco de Loja.

## 📁 Archivos Incluidos

### 1. `01_crear_base_datos.sql`
**Propósito:** Crear la estructura completa de la base de datos
- ✅ Base de datos `pagos_qr_sistema`
- ✅ Tablas: `Cuentas`, `Comercios`, `Pagos_QR`, `Auditoria_Transacciones`, `Limites_Diarios`
- ✅ Vistas útiles para consultas
- ✅ Procedimiento almacenado `sp_procesar_pago_qr`
- ✅ Configuración de variables del sistema

### 2. `02_insertar_datos_practica.sql`
**Propósito:** Poblar la base de datos con datos realistas
- 👥 10 cuentas de estudiantes (María José, Edgar, Anyela, etc.)
- 🏪 10 comercios afiliados (restaurantes, farmacias, transporte, etc.)
- 💳 25 transacciones históricas y actuales
- 📊 Límites diarios configurados
- 🔍 Registros de auditoría

### 3. `03_ejercicios_practica_concurrencia.sql`
**Propósito:** Ejercicios prácticos paso a paso
- 🔄 Pagos simultáneos al mismo comercio
- ⚠️ Simulación de deadlocks
- 🔒 Niveles de aislamiento
- ⏱️ Timeouts de transacciones
- 🛡️ Procedimientos almacenados seguros

## 🚀 Instrucciones de Instalación

### Paso 1: Crear la Base de Datos
```sql
-- En MySQL Workbench, ejecutar:
source 01_crear_base_datos.sql;
```

### Paso 2: Insertar Datos de Práctica
```sql
-- Ejecutar después del Paso 1:
source 02_insertar_datos_practica.sql;
```

### Paso 3: Verificar Instalación
```sql
-- Verificar que todo esté correcto:
USE pagos_qr_sistema;
SELECT COUNT(*) AS total_cuentas FROM Cuentas;
SELECT COUNT(*) AS total_comercios FROM Comercios;
SELECT COUNT(*) AS total_transacciones FROM Pagos_QR;
```

**Resultados esperados:**
- `total_cuentas`: 20 (10 clientes + 10 comercios)
- `total_comercios`: 10
- `total_transacciones`: 25

## 🎓 Ejercicios Prácticos

### 🔧 Preparación
1. **Abrir DOS ventanas** de MySQL Workbench
2. **Conectarse** a la misma base de datos en ambas
3. **Ejecutar** `USE pagos_qr_sistema;` en ambas ventanas

### 📚 Ejercicio 1: Pagos Simultáneos
**Objetivo:** Observar bloqueos en cuenta de comercio (hotspot)

**Ventana 1 (María José):**
```sql
START TRANSACTION;
SELECT saldo FROM Cuentas WHERE id = 101 FOR UPDATE;
UPDATE Cuentas SET saldo = saldo - 2.50 WHERE id = 101;
UPDATE Cuentas SET saldo = saldo + 2.50 WHERE id = 201;
-- ESPERAR antes de COMMIT
COMMIT;
```

**Ventana 2 (Edgar) - Ejecutar simultáneamente:**
```sql
START TRANSACTION;
SELECT saldo FROM Cuentas WHERE id = 102 FOR UPDATE;
UPDATE Cuentas SET saldo = saldo - 1.25 WHERE id = 102;
UPDATE Cuentas SET saldo = saldo + 1.25 WHERE id = 201; -- ¿Espera aquí?
COMMIT;
```

**🔍 Observar:** La segunda transacción espera hasta que la primera haga COMMIT.

### ⚠️ Ejercicio 2: Deadlock Simulado
**Objetivo:** Provocar y observar resolución automática de deadlock

**Ventana 1:**
```sql
START TRANSACTION;
SELECT saldo FROM Cuentas WHERE id = 101 FOR UPDATE; -- Bloquea María José
-- Esperar 3 segundos
SELECT saldo FROM Cuentas WHERE id = 106 FOR UPDATE; -- Intenta bloquear Joseph
```

**Ventana 2:**
```sql
START TRANSACTION;
SELECT saldo FROM Cuentas WHERE id = 106 FOR UPDATE; -- Bloquea Joseph
-- Esperar 2 segundos
SELECT saldo FROM Cuentas WHERE id = 101 FOR UPDATE; -- ¡DEADLOCK!
```

**🔍 Observar:** MySQL detecta el deadlock y aborta una transacción automáticamente.

### 🔒 Ejercicio 3: Niveles de Aislamiento
**Objetivo:** Comparar READ COMMITTED vs REPEATABLE READ

**Ventana 1:**
```sql
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT saldo FROM Cuentas WHERE id = 103; -- Primera lectura
-- ESPERAR modificación externa
SELECT saldo FROM Cuentas WHERE id = 103; -- Segunda lectura (mismo valor)
COMMIT;
SELECT saldo FROM Cuentas WHERE id = 103; -- Tercera lectura (valor actualizado)
```

**Ventana 2:**
```sql
-- Modificar durante la transacción de Ventana 1
START TRANSACTION;
UPDATE Cuentas SET saldo = saldo - 5.00 WHERE id = 103;
COMMIT;
```

## 📊 Consultas de Monitoreo

### Ver Bloqueos Activos
```sql
SELECT 
    r.trx_id AS transaccion_bloqueada,
    b.trx_id AS transaccion_bloqueante,
    r.trx_query AS consulta_esperando
FROM information_schema.INNODB_LOCK_WAITS w
JOIN information_schema.INNODB_TRX r ON r.trx_id = w.requesting_trx_id
JOIN information_schema.INNODB_TRX b ON b.trx_id = w.blocking_trx_id;
```

### Ver Transacciones Activas
```sql
SELECT 
    trx_id,
    trx_state,
    trx_started,
    trx_mysql_thread_id,
    trx_query
FROM information_schema.INNODB_TRX;
```

### Ver Estadísticas de Deadlocks
```sql
SHOW ENGINE INNODB STATUS;
```

## 🎯 Conceptos Clave a Observar

### ✅ Propiedades ACID
- **Atomicidad:** Transacciones completas o nada
- **Consistencia:** Saldos siempre válidos (≥ 0)
- **Aislamiento:** Transacciones independientes
- **Durabilidad:** Cambios permanentes tras COMMIT

### 🔐 Control de Concurrencia
- **Bloqueos exclusivos:** `FOR UPDATE`
- **Bloqueos compartidos:** `FOR SHARE`
- **Hotspots:** Cuentas de comercios populares
- **Deadlock detection:** Resolución automática

### 📈 Niveles de Aislamiento
- **READ UNCOMMITTED:** Lecturas sucias (no usar en finanzas)
- **READ COMMITTED:** Evita lecturas sucias
- **REPEATABLE READ:** Lecturas consistentes (default MySQL)
- **SERIALIZABLE:** Máximo aislamiento

## 🛠️ Configuración Recomendada

```sql
-- Timeout de bloqueos (5 segundos)
SET SESSION innodb_lock_wait_timeout = 5;

-- Detección de deadlocks habilitada
SET GLOBAL innodb_deadlock_detect = ON;

-- Nivel de aislamiento por defecto
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
```

## 🧹 Limpieza Después de Práctica

```sql
-- Eliminar transacciones de práctica
DELETE FROM Pagos_QR WHERE payment_id LIKE '%_EJ%';

-- Restaurar saldos originales
UPDATE Cuentas SET saldo = 25.00 WHERE id = 101;  -- María José
UPDATE Cuentas SET saldo = 18.75 WHERE id = 102;  -- Edgar
-- ... (ver archivo completo para todos los saldos)
```

## 📚 Datos de Estudiantes Incluidos

| ID  | Nombre                    | Saldo Inicial | Límite Diario |
|-----|---------------------------|---------------|---------------|
| 101 | María José Rodríguez      | $25.00        | $50.00        |
| 102 | Edgar Andrés Morales      | $18.75        | $40.00        |
| 103 | Anyela Patricia Vega      | $32.50        | $60.00        |
| 104 | Carlo Sebastián Torres    | $45.00        | $80.00        |
| 105 | Paula Andrea Jiménez      | $12.25        | $35.00        |
| 106 | Joseph Alexander Cruz     | $28.00        | $55.00        |
| 107 | Daniela Michelle López    | $22.75        | $45.00        |
| 108 | Kevin Alejandro Ruiz      | $35.50        | $70.00        |
| 109 | Sofía Valentina Herrera   | $19.25        | $40.00        |
| 110 | Mateo Nicolás Vargas      | $41.00        | $75.00        |

## 🏪 Comercios Afiliados

| ID | Nombre                           | Categoría    | Ciudad    |
|----|----------------------------------|--------------|-----------|
| 1  | Restaurante Universitario La Casona | RESTAURANTE  | Loja      |
| 2  | Cooperativa de Transporte Loja   | TRANSPORTE   | Loja      |
| 3  | Farmacia San Agustín             | FARMACIA     | Loja      |
| 4  | Gasolinera Primax Centro         | GASOLINERA   | Loja      |
| 5  | Cafetería UIDE Campus            | CAFETERIA    | Loja      |

## 🎓 Objetivos de Aprendizaje

Al completar estas prácticas, los estudiantes podrán:

1. ✅ **Implementar transacciones** con sintaxis MySQL correcta
2. ✅ **Observar propiedades ACID** en acción
3. ✅ **Manejar concurrencia** y bloqueos
4. ✅ **Resolver deadlocks** automáticamente
5. ✅ **Configurar niveles de aislamiento** apropiados
6. ✅ **Monitorear transacciones** activas
7. ✅ **Usar procedimientos almacenados** seguros

## 🆘 Solución de Problemas

### Error: "Lock wait timeout exceeded"
**Causa:** Una transacción está esperando un bloqueo por más tiempo del configurado.
**Solución:** Hacer COMMIT o ROLLBACK en la transacción que mantiene el bloqueo.

### Error: "Deadlock found when trying to get lock"
**Causa:** Deadlock detectado automáticamente por MySQL.
**Solución:** Reintentar la transacción que fue abortada.

### No se ven bloqueos
**Causa:** Las transacciones se ejecutan muy rápido.
**Solución:** Agregar pausas (`SELECT SLEEP(5);`) entre comandos.

## 📞 Soporte

Para dudas sobre estos ejercicios:
- **Profesor:** Charlie Cárdenas Toledo, M.Sc.
- **Curso:** 05 LTI_05A_300-SGBD-ASC
- **Universidad:** Universidad Internacional del Ecuador

---
*Basado en MySQL 8.4 Official Documentation y mejores prácticas de sistemas financieros.*