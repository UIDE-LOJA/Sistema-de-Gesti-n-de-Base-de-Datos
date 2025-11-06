-- =====================================================
-- PE 1.2: Práctica de Propiedades ACID
-- Sistema de Pagos QR "¡ahorita!"
-- Semana 2 - SGBD
-- =====================================================

-- PREPARACIÓN: Ejecutar solo una vez
-- Usar las tablas ya creadas en 01_crear_base_datos.sql
-- y los datos de 02_insertar_datos_practica.sql

-- Verificar datos iniciales
SELECT 'ESTADO INICIAL' as fase;
SELECT id, titular, saldo FROM Cuentas WHERE id IN (101, 102, 103, 104, 105);
SELECT id, nombre, cuenta_bancoloja FROM Comercios WHERE id IN (201, 202, 203, 204, 205);

-- =====================================================
-- PRUEBA 1: ATOMICIDAD
-- Simular falla durante transacción de pago
-- =====================================================

SELECT 'PRUEBA 1: ATOMICIDAD' as fase;

-- SESIÓN A: Ejecutar paso a paso
-- Paso 1: Iniciar transacción
START TRANSACTION;

-- Paso 2: Verificar saldo inicial de María José
SELECT 'Saldo inicial María José:' as descripcion, saldo FROM Cuentas WHERE id = 101;

-- Paso 3: Debitar cuenta de María José
UPDATE Cuentas SET saldo = saldo - 2.50 WHERE id = 101;
SELECT 'Después del débito:' as descripcion, saldo FROM Cuentas WHERE id = 101;

-- Paso 4: SIMULAR FALLA AQUÍ
-- Opción A: Cerrar la sesión sin hacer COMMIT
-- Opción B: Ejecutar ROLLBACK;
ROLLBACK;

-- Paso 5: Verificar que el saldo se restauró
SELECT 'Después del ROLLBACK:' as descripcion, saldo FROM Cuentas WHERE id = 101;

-- =====================================================
-- PRUEBA 2: CONSISTENCIA
-- Intentar violar reglas de negocio
-- =====================================================

SELECT 'PRUEBA 2: CONSISTENCIA' as fase;

-- Violación 1: Sobregiro (saldo negativo)
START TRANSACTION;
-- Edgar tiene $25.00, intenta pagar $30.00
UPDATE Cuentas SET saldo = saldo - 30.00 WHERE id = 102;
-- Esto debe fallar por el constraint chk_saldo_positivo
ROLLBACK;

-- Violación 2: Monto negativo en pago
START TRANSACTION;
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado) 
VALUES ('PAY_TEST_NEG', 101, 201, -5.00, NOW(), 'PROCESANDO');
-- Esto debe fallar por el constraint chk_monto_positivo
ROLLBACK;

-- Violación 3: Cliente inexistente
START TRANSACTION;
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado) 
VALUES ('PAY_TEST_FK', 999, 201, 10.00, NOW(), 'PROCESANDO');
-- Esto debe fallar por foreign key constraint
ROLLBACK;

-- =====================================================
-- PRUEBA 3: AISLAMIENTO (CONCURRENCIA)
-- Ejecutar en dos sesiones simultáneamente
-- =====================================================

SELECT 'PRUEBA 3: AISLAMIENTO' as fase;

-- SESIÓN A: Pago de Anyela ($8.75 al restaurante)
-- Ejecutar estos comandos en una sesión
START TRANSACTION;
SELECT 'Sesión A - Saldo inicial restaurante:' as descripcion, saldo FROM Cuentas WHERE id = 205;
UPDATE Cuentas SET saldo = saldo - 8.75 WHERE id = 103; -- Débito Anyela
UPDATE Cuentas SET saldo = saldo + 8.75 WHERE id = 205; -- Crédito restaurante
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado) 
VALUES ('PAY_ANYELA_001', 103, 202, 8.75, NOW(), 'CONFIRMADO');
SELECT 'Sesión A - Antes del COMMIT:' as descripcion, saldo FROM Cuentas WHERE id = 205;
-- ESPERAR 10 segundos antes del COMMIT para ver concurrencia
SELECT SLEEP(10);
COMMIT;
SELECT 'Sesión A - Después del COMMIT:' as descripcion, saldo FROM Cuentas WHERE id = 205;

-- SESIÓN B: Pago de Carlo ($15.00 al mismo restaurante)
-- Ejecutar estos comandos en otra sesión AL MISMO TIEMPO
START TRANSACTION;
SELECT 'Sesión B - Saldo inicial restaurante:' as descripcion, saldo FROM Cuentas WHERE id = 205;
UPDATE Cuentas SET saldo = saldo - 15.00 WHERE id = 104; -- Débito Carlo
UPDATE Cuentas SET saldo = saldo + 15.00 WHERE id = 205; -- Crédito restaurante
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado) 
VALUES ('PAY_CARLO_001', 104, 202, 15.00, NOW(), 'CONFIRMADO');
SELECT 'Sesión B - Antes del COMMIT:' as descripcion, saldo FROM Cuentas WHERE id = 205;
COMMIT;
SELECT 'Sesión B - Después del COMMIT:' as descripcion, saldo FROM Cuentas WHERE id = 205;

-- =====================================================
-- PRUEBA 4: DURABILIDAD
-- Verificar persistencia después de COMMIT
-- =====================================================

SELECT 'PRUEBA 4: DURABILIDAD' as fase;

-- Pago de Paula
START TRANSACTION;
SELECT 'Saldo inicial Paula:' as descripcion, saldo FROM Cuentas WHERE id = 105;
UPDATE Cuentas SET saldo = saldo - 1.25 WHERE id = 105; -- Débito Paula
UPDATE Cuentas SET saldo = saldo + 1.25 WHERE id = 203; -- Crédito cafetería
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado) 
VALUES ('PAY_PAULA_001', 105, 203, 1.25, NOW(), 'CONFIRMADO');
COMMIT;

-- Verificar que el cambio persiste
SELECT 'Después del COMMIT - Paula:' as descripcion, saldo FROM Cuentas WHERE id = 105;
SELECT 'Después del COMMIT - Cafetería:' as descripcion, saldo FROM Cuentas WHERE id = 203;

-- Simular "reinicio del sistema" (nueva conexión)
-- Los cambios deben seguir ahí
SELECT 'VERIFICACIÓN DE DURABILIDAD' as fase;
SELECT id, titular, saldo FROM Cuentas WHERE id IN (105, 203);
SELECT * FROM Pagos_QR WHERE payment_id = 'PAY_PAULA_001';

-- =====================================================
-- CONSULTAS DE VERIFICACIÓN FINAL
-- =====================================================

SELECT 'ESTADO FINAL' as fase;

-- Resumen de saldos
SELECT 
    c.id,
    c.titular,
    c.saldo,
    COUNT(p.payment_id) as total_pagos,
    COALESCE(SUM(CASE WHEN p.cliente_id = c.id THEN p.monto ELSE 0 END), 0) as total_gastado,
    COALESCE(SUM(CASE WHEN com.cuenta_bancoloja = c.id THEN p.monto ELSE 0 END), 0) as total_recibido
FROM Cuentas c
LEFT JOIN Pagos_QR p ON (p.cliente_id = c.id OR EXISTS(SELECT 1 FROM Comercios com WHERE com.cuenta_bancoloja = c.id AND com.id = p.comercio_id))
LEFT JOIN Comercios com ON com.cuenta_bancoloja = c.id
WHERE c.id IN (101, 102, 103, 104, 105, 201, 202, 203, 204, 205)
GROUP BY c.id, c.titular, c.saldo
ORDER BY c.id;

-- Verificar conservación del dinero (suma total debe ser constante)
SELECT 'CONSERVACIÓN DEL DINERO' as verificacion, SUM(saldo) as total_sistema FROM Cuentas;

-- Historial de transacciones
SELECT 
    p.payment_id,
    c1.titular as cliente,
    com.nombre as comercio,
    p.monto,
    p.fecha,
    p.estado
FROM Pagos_QR p
JOIN Cuentas c1 ON c1.id = p.cliente_id
JOIN Comercios com ON com.id = p.comercio_id
ORDER BY p.fecha DESC;

-- =====================================================
-- COMANDOS PARA LIMPIAR Y REINICIAR
-- =====================================================

-- Ejecutar solo si quieres reiniciar las pruebas
/*
DELETE FROM Pagos_QR WHERE payment_id LIKE 'PAY_%_001';
UPDATE Cuentas SET saldo = 25.00 WHERE id IN (101, 102, 103, 104, 105);
UPDATE Cuentas SET saldo = 200.00 WHERE id IN (201, 202, 203, 204, 205);
*/