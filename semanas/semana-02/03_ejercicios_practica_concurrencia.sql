-- =====================================================
-- EJERCICIOS DE PRÁCTICA: CONCURRENCIA Y TRANSACCIONES
-- Semana 2: Transacciones y Control de Concurrencia
-- Sistema de Pagos QR "¡ahorita!" - Banco de Loja
-- =====================================================

USE pagos_qr_sistema;

-- =====================================================
-- INSTRUCCIONES PARA LA PRÁCTICA
-- =====================================================

/*
IMPORTANTE: Para realizar estos ejercicios necesitas:

1. Abrir DOS ventanas de MySQL Workbench
2. Conectarte a la misma base de datos en ambas ventanas
3. Ejecutar los comandos de SESIÓN 1 en la primera ventana
4. Ejecutar los comandos de SESIÓN 2 en la segunda ventana
5. Seguir el orden temporal indicado en cada ejercicio

OBJETIVO: Observar el comportamiento de bloqueos, esperas y resolución de deadlocks
*/

-- =====================================================
-- EJERCICIO 1: PAGOS SIMULTÁNEOS AL MISMO COMERCIO
-- Objetivo: Observar bloqueos en cuenta de comercio (hotspot)
-- =====================================================

SELECT 'EJERCICIO 1: PAGOS SIMULTÁNEOS AL MISMO COMERCIO' AS ejercicio;
SELECT 'Dos estudiantes pagan simultáneamente en el Restaurante La Casona' AS descripcion;

-- Verificar saldos iniciales
SELECT 
    'SALDOS INICIALES' AS momento,
    c.id,
    c.titular,
    c.saldo
FROM Cuentas c 
WHERE c.id IN (101, 102, 201)  -- María José, Edgar, Restaurante
ORDER BY c.id;

/*
-- ===== SESIÓN 1: María José paga $2.50 =====
-- Ejecutar paso a paso, esperando entre cada comando

START TRANSACTION;

-- Paso 1: Bloquear cuenta de María José
SELECT saldo FROM Cuentas WHERE id = 101 FOR UPDATE;
-- Resultado esperado: Saldo actual de María José

-- Paso 2: Verificar saldo suficiente y debitar
UPDATE Cuentas SET saldo = saldo - 2.50 WHERE id = 101;
-- Resultado: 1 row affected

-- Paso 3: Intentar acreditar al restaurante (AQUÍ PUEDE HABER ESPERA)
UPDATE Cuentas SET saldo = saldo + 2.50 WHERE id = 201;
-- Si SESIÓN 2 ya bloqueó la cuenta 201, esta operación ESPERARÁ

-- Paso 4: Registrar la transacción
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, descripcion, estado) 
VALUES ('PAY_20241106_101_201_EJ1', 101, 1, 2.50, 'Ejercicio 1 - María José', 'CONFIRMADO');

-- Paso 5: Confirmar transacción (libera todos los bloqueos)
COMMIT;
*/

/*
-- ===== SESIÓN 2: Edgar paga $1.25 (EJECUTAR SIMULTÁNEAMENTE) =====
-- Ejecutar inmediatamente después del Paso 2 de SESIÓN 1

START TRANSACTION;

-- Paso 1: Bloquear cuenta de Edgar
SELECT saldo FROM Cuentas WHERE id = 102 FOR UPDATE;
-- Resultado esperado: Saldo actual de Edgar

-- Paso 2: Verificar saldo suficiente y debitar
UPDATE Cuentas SET saldo = saldo - 1.25 WHERE id = 102;
-- Resultado: 1 row affected

-- Paso 3: Intentar acreditar al restaurante (CONFLICTO CON SESIÓN 1)
UPDATE Cuentas SET saldo = saldo + 1.25 WHERE id = 201;
-- Esta operación ESPERARÁ hasta que SESIÓN 1 haga COMMIT

-- Paso 4: Registrar la transacción
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, descripcion, estado) 
VALUES ('PAY_20241106_102_201_EJ1', 102, 1, 1.25, 'Ejercicio 1 - Edgar', 'CONFIRMADO');

-- Paso 5: Confirmar transacción
COMMIT;
*/

-- Verificar resultados del ejercicio 1
SELECT 'RESULTADOS EJERCICIO 1' AS resultado;
SELECT 
    c.id,
    c.titular,
    c.saldo,
    'Saldo después del ejercicio' AS nota
FROM Cuentas c 
WHERE c.id IN (101, 102, 201)
ORDER BY c.id;

-- =====================================================
-- EJERCICIO 2: DEADLOCK SIMULADO (TRANSFERENCIAS CRUZADAS)
-- Objetivo: Provocar y observar resolución automática de deadlock
-- =====================================================

SELECT 'EJERCICIO 2: DEADLOCK SIMULADO' AS ejercicio;
SELECT 'Transferencias cruzadas entre María José y Joseph' AS descripcion;

-- Verificar saldos iniciales
SELECT 
    'SALDOS INICIALES EJERCICIO 2' AS momento,
    c.id,
    c.titular,
    c.saldo
FROM Cuentas c 
WHERE c.id IN (101, 106)  -- María José, Joseph
ORDER BY c.id;

/*
-- ===== SESIÓN 1: María José transfiere $5.00 a Joseph =====

START TRANSACTION;

-- Paso 1: Bloquear cuenta de María José (origen)
SELECT saldo FROM Cuentas WHERE id = 101 FOR UPDATE;
-- Esperar 3 segundos antes del siguiente paso

-- Paso 2: Intentar bloquear cuenta de Joseph (destino)
-- EJECUTAR ESTE PASO DESPUÉS DE QUE SESIÓN 2 EJECUTE SU PASO 1
SELECT saldo FROM Cuentas WHERE id = 106 FOR UPDATE;
-- DEADLOCK: Esta operación esperará indefinidamente

-- Si no hay deadlock, continuar:
UPDATE Cuentas SET saldo = saldo - 5.00 WHERE id = 101;
UPDATE Cuentas SET saldo = saldo + 5.00 WHERE id = 106;

COMMIT;
*/

/*
-- ===== SESIÓN 2: Joseph transfiere $3.00 a María José =====
-- EJECUTAR INMEDIATAMENTE DESPUÉS DEL PASO 1 DE SESIÓN 1

START TRANSACTION;

-- Paso 1: Bloquear cuenta de Joseph (origen)
SELECT saldo FROM Cuentas WHERE id = 106 FOR UPDATE;
-- Esperar 2 segundos antes del siguiente paso

-- Paso 2: Intentar bloquear cuenta de María José (destino)
SELECT saldo FROM Cuentas WHERE id = 101 FOR UPDATE;
-- DEADLOCK DETECTADO: MySQL abortará una de las dos transacciones

-- Si esta sesión sobrevive al deadlock, continuar:
UPDATE Cuentas SET saldo = saldo - 3.00 WHERE id = 106;
UPDATE Cuentas SET saldo = saldo + 3.00 WHERE id = 101;

COMMIT;
*/

-- Verificar qué transacción sobrevivió al deadlock
SELECT 'RESULTADOS EJERCICIO 2 (DEADLOCK)' AS resultado;
SELECT 
    c.id,
    c.titular,
    c.saldo,
    'Saldo después del deadlock' AS nota
FROM Cuentas c 
WHERE c.id IN (101, 106)
ORDER BY c.id;

-- =====================================================
-- EJERCICIO 3: NIVELES DE AISLAMIENTO
-- Objetivo: Observar diferencias entre niveles de aislamiento
-- =====================================================

SELECT 'EJERCICIO 3: NIVELES DE AISLAMIENTO' AS ejercicio;
SELECT 'Comparar READ COMMITTED vs REPEATABLE READ' AS descripcion;

/*
-- ===== SESIÓN 1: Consulta de saldo con REPEATABLE READ =====

-- Configurar nivel de aislamiento
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION;

-- Paso 1: Primera lectura del saldo de Anyela
SELECT saldo, 'Primera lectura' AS momento 
FROM Cuentas WHERE id = 103;

-- ESPERAR A QUE SESIÓN 2 MODIFIQUE EL SALDO

-- Paso 2: Segunda lectura del mismo saldo (después de modificación externa)
SELECT saldo, 'Segunda lectura (después de modificación)' AS momento 
FROM Cuentas WHERE id = 103;
-- Con REPEATABLE READ: debería ver el MISMO saldo que en la primera lectura

COMMIT;

-- Paso 3: Tercera lectura (después de COMMIT)
SELECT saldo, 'Tercera lectura (después de COMMIT)' AS momento 
FROM Cuentas WHERE id = 103;
-- Ahora debería ver el saldo modificado
*/

/*
-- ===== SESIÓN 2: Modificar saldo durante transacción de SESIÓN 1 =====
-- EJECUTAR DESPUÉS DEL PASO 1 DE SESIÓN 1

-- Anyela compra medicamentos por $5.50
START TRANSACTION;

UPDATE Cuentas SET saldo = saldo - 5.50 WHERE id = 103;
UPDATE Cuentas SET saldo = saldo + 5.50 WHERE id = 203;

INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, descripcion, estado) 
VALUES ('PAY_20241106_103_203_EJ3', 103, 3, 5.50, 'Ejercicio 3 - Medicamentos', 'CONFIRMADO');

COMMIT;
-- Ahora SESIÓN 1 puede ejecutar su Paso 2
*/

-- =====================================================
-- EJERCICIO 4: TIMEOUT DE TRANSACCIONES
-- Objetivo: Observar comportamiento de timeout en bloqueos
-- =====================================================

SELECT 'EJERCICIO 4: TIMEOUT DE TRANSACCIONES' AS ejercicio;
SELECT 'Simular timeout por bloqueo prolongado' AS descripcion;

-- Configurar timeout corto para la demostración
SET SESSION innodb_lock_wait_timeout = 5;

/*
-- ===== SESIÓN 1: Bloqueo prolongado =====

START TRANSACTION;

-- Bloquear cuenta de Carlo
SELECT saldo FROM Cuentas WHERE id = 104 FOR UPDATE;

-- NO HACER COMMIT INMEDIATAMENTE
-- Esperar más de 5 segundos para que SESIÓN 2 experimente timeout
-- Simular procesamiento lento...

-- Después de que SESIÓN 2 experimente timeout:
COMMIT;
*/

/*
-- ===== SESIÓN 2: Intentar acceso que causará timeout =====
-- EJECUTAR DESPUÉS DE QUE SESIÓN 1 BLOQUEE LA CUENTA

START TRANSACTION;

-- Esta operación esperará y luego fallará por timeout
SELECT saldo FROM Cuentas WHERE id = 104 FOR UPDATE;
-- Error esperado: Lock wait timeout exceeded

ROLLBACK;
*/

-- =====================================================
-- EJERCICIO 5: PROCEDIMIENTO ALMACENADO CON MANEJO DE ERRORES
-- Objetivo: Usar el procedimiento creado para pagos seguros
-- =====================================================

SELECT 'EJERCICIO 5: PROCEDIMIENTO ALMACENADO' AS ejercicio;
SELECT 'Usar sp_procesar_pago_qr para transacciones seguras' AS descripcion;

-- Ejemplo de uso del procedimiento almacenado
CALL sp_procesar_pago_qr(
    'PAY_20241106_105_205_PROC1',  -- payment_id
    105,                           -- cliente_id (Paula)
    5,                             -- comercio_id (Cafetería UIDE)
    2.25,                          -- monto
    'Pago con procedimiento almacenado',  -- descripción
    @resultado                     -- variable de salida
);

-- Ver el resultado
SELECT @resultado AS resultado_procedimiento;

-- Intentar pago que excede saldo (debería fallar)
CALL sp_procesar_pago_qr(
    'PAY_20241106_105_205_PROC2',
    105,                           -- Paula
    5,                             -- Cafetería UIDE
    50.00,                         -- Monto mayor al saldo
    'Pago que debería fallar',
    @resultado2
);

SELECT @resultado2 AS resultado_pago_fallido;

-- =====================================================
-- CONSULTAS DE MONITOREO DURANTE LAS PRÁCTICAS
-- =====================================================

-- Ver transacciones activas
SELECT 'CONSULTAS DE MONITOREO' AS seccion;

-- Consulta 1: Ver bloqueos activos
SELECT 
    r.trx_id AS transaccion_bloqueada,
    r.trx_mysql_thread_id AS thread_bloqueado,
    r.trx_query AS consulta_bloqueada,
    b.trx_id AS transaccion_bloqueante,
    b.trx_mysql_thread_id AS thread_bloqueante,
    b.trx_query AS consulta_bloqueante
FROM information_schema.INNODB_LOCK_WAITS w
JOIN information_schema.INNODB_TRX r ON r.trx_id = w.requesting_trx_id
JOIN information_schema.INNODB_TRX b ON b.trx_id = w.blocking_trx_id;

-- Consulta 2: Ver todas las transacciones activas
SELECT 
    trx_id,
    trx_state,
    trx_started,
    trx_mysql_thread_id,
    trx_query
FROM information_schema.INNODB_TRX;

-- Consulta 3: Ver estadísticas de deadlocks
SHOW ENGINE INNODB STATUS;

-- =====================================================
-- LIMPIEZA DESPUÉS DE LAS PRÁCTICAS
-- =====================================================

-- Script para limpiar transacciones de práctica
/*
DELETE FROM Pagos_QR 
WHERE payment_id LIKE '%_EJ%' OR payment_id LIKE '%_PROC%';

-- Restaurar saldos originales si es necesario
UPDATE Cuentas SET saldo = 25.00 WHERE id = 101;  -- María José
UPDATE Cuentas SET saldo = 18.75 WHERE id = 102;  -- Edgar
UPDATE Cuentas SET saldo = 32.50 WHERE id = 103;  -- Anyela
UPDATE Cuentas SET saldo = 45.00 WHERE id = 104;  -- Carlo
UPDATE Cuentas SET saldo = 12.25 WHERE id = 105;  -- Paula
UPDATE Cuentas SET saldo = 28.00 WHERE id = 106;  -- Joseph

-- Restaurar saldos de comercios
UPDATE Cuentas SET saldo = 450.00 WHERE id = 201;  -- Restaurante La Casona
UPDATE Cuentas SET saldo = 275.50 WHERE id = 203;  -- Farmacia San Agustín
UPDATE Cuentas SET saldo = 180.25 WHERE id = 205;  -- Cafetería UIDE
*/

-- =====================================================
-- RESUMEN DE EJERCICIOS
-- =====================================================

SELECT 'RESUMEN DE EJERCICIOS COMPLETADOS' AS resumen;
SELECT 
    'Ejercicio 1: Pagos simultáneos - Observar bloqueos en hotspot' AS ejercicio_1,
    'Ejercicio 2: Deadlock simulado - Ver resolución automática' AS ejercicio_2,
    'Ejercicio 3: Niveles de aislamiento - Comparar comportamientos' AS ejercicio_3,
    'Ejercicio 4: Timeout de transacciones - Manejar esperas prolongadas' AS ejercicio_4,
    'Ejercicio 5: Procedimiento almacenado - Transacciones seguras' AS ejercicio_5;