-- =====================================================
-- PE 1.2: Práctica de Propiedades ACID
-- Sistema de Pagos QR "¡ahorita!"
-- Semana 2 - SGBD
-- =====================================================

-- PREPARACIÓN: Ejecutar solo una vez
-- Usar las tablas ya creadas en 01_crear_base_datos.sql
-- y los datos de 02_insertar_datos_practica.sql

-- Verificar datos iniciales (usando datos actualizados del archivo 02_insertar_datos_practica.sql)
SELECT 'ESTADO INICIAL' as fase;
SELECT id, titular, saldo FROM Cuentas WHERE id IN (101, 102, 103, 104, 105, 106, 107, 108);
SELECT id, nombre, cuenta_bancoloja FROM Comercios WHERE id IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

-- =====================================================
-- PRUEBA 1: ATOMICIDAD
-- Simular falla durante transacción de pago
-- =====================================================

SELECT 'PRUEBA 1: ATOMICIDAD' as fase;

-- SESIÓN A: Ejecutar paso a paso
-- Paso 1: Iniciar transacción
START TRANSACTION;

-- Paso 2: Verificar saldo inicial de Edgar Anderson (ID 101)
SELECT 'Saldo inicial Edgar Anderson:' as descripcion, saldo FROM Cuentas WHERE id = 101;

-- Paso 3: Debitar cuenta de Edgar Anderson
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
-- Hector Antonio tiene $18.75, intenta pagar $30.00
UPDATE Cuentas SET saldo = saldo - 30.00 WHERE id = 102;
-- Esto debe fallar por el constraint chk_saldo_positivo
ROLLBACK;

-- Violación 2: Monto negativo en pago
START TRANSACTION;
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado) 
VALUES ('PAY_TEST_NEG', 101, 1, -5.00, NOW(), 'PROCESANDO');
-- Esto debe fallar por el constraint chk_monto_positivo
ROLLBACK;

-- Violación 3: Cliente inexistente
START TRANSACTION;
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado) 
VALUES ('PAY_TEST_FK', 999, 1, 10.00, NOW(), 'PROCESANDO');
-- Esto debe fallar por foreign key constraint
ROLLBACK;

-- =====================================================
-- PRUEBA 3: AISLAMIENTO (CONCURRENCIA)
-- Ejecutar en dos sesiones simultáneamente
-- =====================================================

SELECT 'PRUEBA 3: AISLAMIENTO' as fase;

-- SESIÓN A: Pago de Anyela Carolina ($8.75 a Cafetería UIDE)
-- Ejecutar estos comandos en una sesión
START TRANSACTION;
SELECT 'Sesión A - Saldo inicial Cafetería UIDE:' as descripcion, saldo FROM Cuentas WHERE id = 202;
UPDATE Cuentas SET saldo = saldo - 8.75 WHERE id = 103; -- Débito Anyela Carolina
UPDATE Cuentas SET saldo = saldo + 8.75 WHERE id = 202; -- Crédito Cafetería UIDE
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado) 
VALUES ('PAY_ANYELA_001', 103, 2, 8.75, NOW(), 'CONFIRMADO');
SELECT 'Sesión A - Antes del COMMIT:' as descripcion, saldo FROM Cuentas WHERE id = 202;
-- ESPERAR 10 segundos antes del COMMIT para ver concurrencia
SELECT SLEEP(10);
COMMIT;
SELECT 'Sesión A - Después del COMMIT:' as descripcion, saldo FROM Cuentas WHERE id = 202;

-- SESIÓN B: Pago de Carlo Sebastián ($15.00 a la misma Cafetería UIDE)
-- Ejecutar estos comandos en otra sesión AL MISMO TIEMPO
START TRANSACTION;
SELECT 'Sesión B - Saldo inicial Cafetería UIDE:' as descripcion, saldo FROM Cuentas WHERE id = 202;
UPDATE Cuentas SET saldo = saldo - 15.00 WHERE id = 104; -- Débito Carlo Sebastián
UPDATE Cuentas SET saldo = saldo + 15.00 WHERE id = 202; -- Crédito Cafetería UIDE
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado) 
VALUES ('PAY_CARLO_001', 104, 2, 15.00, NOW(), 'CONFIRMADO');
SELECT 'Sesión B - Antes del COMMIT:' as descripcion, saldo FROM Cuentas WHERE id = 202;
COMMIT;
SELECT 'Sesión B - Después del COMMIT:' as descripcion, saldo FROM Cuentas WHERE id = 202;

-- =====================================================
-- PRUEBA 4: DURABILIDAD
-- Verificar persistencia después de COMMIT
-- =====================================================

SELECT 'PRUEBA 4: DURABILIDAD' as fase;

-- Pago de Joseph Steven
START TRANSACTION;
SELECT 'Saldo inicial Joseph Steven:' as descripcion, saldo FROM Cuentas WHERE id = 105;
UPDATE Cuentas SET saldo = saldo - 1.25 WHERE id = 105; -- Débito Joseph Steven
UPDATE Cuentas SET saldo = saldo + 1.25 WHERE id = 203; -- Crédito Farmacia San Agustín
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado) 
VALUES ('PAY_JOSEPH_001', 105, 3, 1.25, NOW(), 'CONFIRMADO');
COMMIT;

-- Verificar que el cambio persiste
SELECT 'Después del COMMIT - Joseph Steven:' as descripcion, saldo FROM Cuentas WHERE id = 105;
SELECT 'Después del COMMIT - Farmacia San Agustín:' as descripcion, saldo FROM Cuentas WHERE id = 203;

-- Simular "reinicio del sistema" (nueva conexión)
-- Los cambios deben seguir ahí
SELECT 'VERIFICACIÓN DE DURABILIDAD' as fase;
SELECT id, titular, saldo FROM Cuentas WHERE id IN (105, 203);
SELECT * FROM Pagos_QR WHERE payment_id = 'PAY_JOSEPH_001';

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
-- Restaurar saldos originales según 02_insertar_datos_practica.sql
UPDATE Cuentas SET saldo = 25.00 WHERE id = 101;  -- Edgar Anderson
UPDATE Cuentas SET saldo = 18.75 WHERE id = 102;  -- Hector Antonio
UPDATE Cuentas SET saldo = 32.50 WHERE id = 103;  -- Anyela Carolina
UPDATE Cuentas SET saldo = 45.00 WHERE id = 104;  -- Carlo Sebastián
UPDATE Cuentas SET saldo = 12.25 WHERE id = 105;  -- Joseph Steven
-- Restaurar saldos de comercios
UPDATE Cuentas SET saldo = 450.00 WHERE id = 201; -- Cooperativa Transportes
UPDATE Cuentas SET saldo = 320.75 WHERE id = 202; -- Cafetería UIDE
UPDATE Cuentas SET saldo = 275.50 WHERE id = 203; -- Farmacia San Agustín
UPDATE Cuentas SET saldo = 1250.00 WHERE id = 204; -- Gasolinera Primax
UPDATE Cuentas SET saldo = 180.25 WHERE id = 205; -- Farmacia Cruz Azul
*/