-- =====================================================
-- PE-1.3 PRÁCTICA DESARROLLADA (Versión Simplificada)
-- Laboratorio: Binary Log en MySQL
-- Sistema de Pagos QR "¡ahorita!" - Banco de Loja
-- Duración: 60 minutos
-- =====================================================
-- Estudiante: [Tu Nombre Completo]
-- Cuenta asignada: ID [Tu ID entre 101-127]
-- =====================================================

-- =====================================================
-- PASO 1: VERIFICAR BINARY LOG (5 minutos)
-- =====================================================

-- 1.1 Verificar si está activo
SHOW VARIABLES LIKE 'log_bin';
-- 📸 CAPTURA 1: Resultado debe mostrar "ON"

-- =====================================================
-- PASO 2: EJECUTAR TRANSACCIONES DE PAGO (30 minutos)
-- =====================================================

USE pagos_qr_sistema;

-- 2.1 Ver tu saldo inicial
-- IMPORTANTE: Reemplaza XXX con tu ID asignado (ejemplo: 101, 102, etc.)
SELECT id, titular, saldo, limite_diario
FROM Cuentas
WHERE id = XXX;  -- <-- CAMBIAR XXX POR TU ID
-- 📸 CAPTURA 2: Tu saldo inicial

-- Saldo inicial anotado: $_______

-- =====================================================
-- TRANSACCIÓN 1: Pago en Cafetería UIDE
-- =====================================================
START TRANSACTION;

UPDATE Cuentas SET saldo = saldo - 2.50 WHERE id = XXX;  -- Tu cuenta
UPDATE Cuentas SET saldo = saldo + 2.50 WHERE id = 202;  -- Cafetería

INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, descripcion, estado, metodo_pago)
VALUES (
    CONCAT('PAY_PE13_', XXX, '_001'),  -- Reemplaza XXX con tu ID
    XXX,  -- Tu ID
    2,
    2.50,
    'PE 1.3 - Desayuno',
    'CONFIRMADO',
    'QR_AHORITA'
);

COMMIT;
-- 📸 CAPTURA 3: Confirmación del COMMIT

-- =====================================================
-- TRANSACCIÓN 2: Pago de transporte
-- =====================================================
START TRANSACTION;

UPDATE Cuentas SET saldo = saldo - 0.35 WHERE id = XXX;  -- Tu cuenta
UPDATE Cuentas SET saldo = saldo + 0.35 WHERE id = 208;  -- Transporte

INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, descripcion, estado, metodo_pago)
VALUES (
    CONCAT('PAY_PE13_', XXX, '_002'),
    XXX,
    8,
    0.35,
    'PE 1.3 - Pasaje',
    'CONFIRMADO',
    'QR_AHORITA'
);

COMMIT;

-- =====================================================
-- TRANSACCIÓN 3: Pago en minimarket
-- =====================================================
START TRANSACTION;

UPDATE Cuentas SET saldo = saldo - 1.50 WHERE id = XXX;  -- Tu cuenta
UPDATE Cuentas SET saldo = saldo + 1.50 WHERE id = 206;  -- Minimarket

INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, descripcion, estado, metodo_pago)
VALUES (
    CONCAT('PAY_PE13_', XXX, '_003'),
    XXX,
    6,
    1.50,
    'PE 1.3 - Snacks',
    'CONFIRMADO',
    'QR_AHORITA'
);

COMMIT;

-- 2.2 Verificar tu saldo final
SELECT id, titular, saldo
FROM Cuentas
WHERE id = XXX;  -- Tu ID
-- 📸 CAPTURA 4: Tu saldo final

-- Saldo final: $_______
-- Cambio esperado: -$4.35 ($2.50 + $0.35 + $1.50)

-- 2.3 Ver tus transacciones
SELECT payment_id, monto, descripcion, estado, fecha
FROM Pagos_QR
WHERE payment_id LIKE CONCAT('PAY_PE13_', XXX, '%')
ORDER BY fecha;
-- 📸 CAPTURA 5: Tus 3 transacciones

-- =====================================================
-- PASO 3: VER BINARY LOGS (15 minutos)
-- =====================================================

-- 3.1 Lista de archivos de binary log
SHOW BINARY LOGS;
-- 📸 CAPTURA 6: Lista de binary logs

-- Archivo actual: ___________________
-- Tamaño: __________ bytes

-- 3.2 Ver últimos eventos del log
SHOW BINLOG EVENTS LIMIT 10;
-- 📸 CAPTURA 7: Eventos del binary log

-- =====================================================
-- PASO 4: EXPLICACIÓN (10 minutos)
-- =====================================================
-- Escribe 2-3 líneas explicando:
-- ¿Para qué sirve el binary log en el Sistema de Pagos QR?

-- TU RESPUESTA:
-- 1. ________________________________________________________
-- 2. ________________________________________________________
-- 3. ________________________________________________________

-- =====================================================
-- FIN DE LA PRÁCTICA
-- =====================================================
-- IMPORTANTE:
-- - Incluir las 7 capturas en el PDF
-- - Nomenclatura: PE-1.3_ApellidoNombre_WAL.pdf
-- =====================================================
