-- =====================================================
-- SCRIPT DE INSERCIÓN DE DATOS DE PRÁCTICA
-- Semana 2: Transacciones y Control de Concurrencia
-- Sistema de Pagos QR "¡ahorita!" - Banco de Loja
-- =====================================================

USE pagos_qr_sistema;

-- =====================================================
-- INSERTAR CUENTAS DE ESTUDIANTES (CLIENTES)
-- =====================================================

INSERT INTO Cuentas (id, titular, saldo, limite_diario, estado) VALUES
-- Estudiantes del curso SGBD
(101, 'María José Rodríguez', 25.00, 50.00, 'ACTIVA'),
(102, 'Edgar Andrés Morales', 18.75, 40.00, 'ACTIVA'),
(103, 'Anyela Patricia Vega', 32.50, 60.00, 'ACTIVA'),
(104, 'Carlo Sebastián Torres', 45.00, 80.00, 'ACTIVA'),
(105, 'Paula Andrea Jiménez', 12.25, 35.00, 'ACTIVA'),
(106, 'Joseph Alexander Cruz', 28.00, 55.00, 'ACTIVA'),
(107, 'Daniela Michelle López', 22.75, 45.00, 'ACTIVA'),
(108, 'Kevin Alejandro Ruiz', 35.50, 70.00, 'ACTIVA'),
(109, 'Sofía Valentina Herrera', 19.25, 40.00, 'ACTIVA'),
(110, 'Mateo Nicolás Vargas', 41.00, 75.00, 'ACTIVA');

-- =====================================================
-- INSERTAR CUENTAS DE COMERCIOS
-- =====================================================

INSERT INTO Cuentas (id, titular, saldo, limite_diario, estado) VALUES
-- Cuentas para comercios
(201, 'Restaurante Universitario La Casona', 450.00, 1000.00, 'ACTIVA'),
(202, 'Cooperativa de Transporte Loja', 320.75, 800.00, 'ACTIVA'),
(203, 'Farmacia San Agustín', 275.50, 600.00, 'ACTIVA'),
(204, 'Gasolinera Primax Centro', 1250.00, 2000.00, 'ACTIVA'),
(205, 'Cafetería UIDE Campus', 180.25, 500.00, 'ACTIVA'),
(206, 'Restaurante El Buen Sabor', 380.00, 900.00, 'ACTIVA'),
(207, 'Farmacia Cruz Azul', 195.75, 550.00, 'ACTIVA'),
(208, 'Transporte Urbano Catamayo', 145.50, 400.00, 'ACTIVA'),
(209, 'Cafetería Central Park', 220.00, 600.00, 'ACTIVA'),
(210, 'Minimarket Don Pepe', 165.25, 450.00, 'ACTIVA');

-- =====================================================
-- INSERTAR COMERCIOS AFILIADOS
-- =====================================================

INSERT INTO Comercios (id, nombre, cuenta_bancoloja, qr_code, ciudad, categoria, estado) VALUES
(1, 'Restaurante Universitario La Casona', 201, 'QR_REST_CASONA_2024_001', 'Loja', 'RESTAURANTE', 'ACTIVO'),
(2, 'Cooperativa de Transporte Loja', 202, 'QR_TRANS_COOP_2024_002', 'Loja', 'TRANSPORTE', 'ACTIVO'),
(3, 'Farmacia San Agustín', 203, 'QR_FARM_SANAG_2024_003', 'Loja', 'FARMACIA', 'ACTIVO'),
(4, 'Gasolinera Primax Centro', 204, 'QR_GAS_PRIMAX_2024_004', 'Loja', 'GASOLINERA', 'ACTIVO'),
(5, 'Cafetería UIDE Campus', 205, 'QR_CAF_UIDE_2024_005', 'Loja', 'CAFETERIA', 'ACTIVO'),
(6, 'Restaurante El Buen Sabor', 206, 'QR_REST_SABOR_2024_006', 'Loja', 'RESTAURANTE', 'ACTIVO'),
(7, 'Farmacia Cruz Azul', 207, 'QR_FARM_CRUZ_2024_007', 'Loja', 'FARMACIA', 'ACTIVO'),
(8, 'Transporte Urbano Catamayo', 208, 'QR_TRANS_CATAM_2024_008', 'Catamayo', 'TRANSPORTE', 'ACTIVO'),
(9, 'Cafetería Central Park', 209, 'QR_CAF_PARK_2024_009', 'Loja', 'CAFETERIA', 'ACTIVO'),
(10, 'Minimarket Don Pepe', 210, 'QR_MINI_PEPE_2024_010', 'Loja', 'OTROS', 'ACTIVO');

-- =====================================================
-- INSERTAR TRANSACCIONES HISTÓRICAS (ÚLTIMOS 3 DÍAS)
-- =====================================================

-- Transacciones de hace 3 días
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado, descripcion, metodo_pago) VALUES
('PAY_20241103_101_001_H001', 101, 1, 2.50, '2024-11-03 12:30:15', 'CONFIRMADO', 'Almuerzo estudiantil', 'QR_SCAN'),
('PAY_20241103_102_002_H002', 102, 2, 0.35, '2024-11-03 07:45:22', 'CONFIRMADO', 'Pasaje urbano', 'QR_SCAN'),
('PAY_20241103_103_003_H003', 103, 3, 8.75, '2024-11-03 16:20:10', 'CONFIRMADO', 'Medicamentos', 'QR_SCAN'),
('PAY_20241103_104_004_H004', 104, 4, 15.00, '2024-11-03 18:15:45', 'CONFIRMADO', 'Gasolina Extra', 'QR_SCAN'),
('PAY_20241103_105_005_H005', 105, 5, 1.25, '2024-11-03 10:30:30', 'CONFIRMADO', 'Café americano', 'QR_SCAN');

-- Transacciones de hace 2 días
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado, descripcion, metodo_pago) VALUES
('PAY_20241104_106_001_H006', 106, 1, 3.00, '2024-11-04 13:15:20', 'CONFIRMADO', 'Almuerzo ejecutivo', 'QR_SCAN'),
('PAY_20241104_107_002_H007', 107, 2, 0.35, '2024-11-04 08:20:15', 'CONFIRMADO', 'Pasaje urbano', 'QR_SCAN'),
('PAY_20241104_108_006_H008', 108, 6, 4.50, '2024-11-04 19:30:45', 'CONFIRMADO', 'Cena ligera', 'QR_SCAN'),
('PAY_20241104_109_007_H009', 109, 7, 6.25, '2024-11-04 11:45:30', 'CONFIRMADO', 'Vitaminas', 'QR_SCAN'),
('PAY_20241104_110_009_H010', 110, 9, 2.75, '2024-11-04 15:10:25', 'CONFIRMADO', 'Cappuccino', 'QR_SCAN');

-- Transacciones de ayer
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado, descripcion, metodo_pago) VALUES
('PAY_20241105_101_005_H011', 101, 5, 1.50, '2024-11-05 09:15:10', 'CONFIRMADO', 'Café con leche', 'QR_SCAN'),
('PAY_20241105_102_008_H012', 102, 8, 0.40, '2024-11-05 17:30:20', 'CONFIRMADO', 'Pasaje intercantonal', 'QR_SCAN'),
('PAY_20241105_103_010_H013', 103, 10, 3.25, '2024-11-05 20:45:15', 'CONFIRMADO', 'Snacks y bebida', 'QR_SCAN'),
('PAY_20241105_104_001_H014', 104, 1, 2.75, '2024-11-05 12:20:30', 'CONFIRMADO', 'Almuerzo vegetariano', 'QR_SCAN'),
('PAY_20241105_105_003_H015', 105, 3, 4.50, '2024-11-05 14:10:45', 'CONFIRMADO', 'Medicamentos básicos', 'QR_SCAN');

-- =====================================================
-- INSERTAR TRANSACCIONES DEL DÍA ACTUAL PARA PRÁCTICA
-- =====================================================

-- Transacciones completadas hoy (para demostrar estados)
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado, descripcion, metodo_pago) VALUES
('PAY_20241106_101_001_T001', 101, 1, 2.50, NOW() - INTERVAL 2 HOUR, 'CONFIRMADO', 'Almuerzo del día', 'QR_SCAN'),
('PAY_20241106_102_002_T002', 102, 2, 0.35, NOW() - INTERVAL 3 HOUR, 'CONFIRMADO', 'Pasaje matutino', 'QR_SCAN'),
('PAY_20241106_103_005_T003', 103, 5, 1.75, NOW() - INTERVAL 1 HOUR, 'CONFIRMADO', 'Café con pastel', 'QR_SCAN');

-- Transacciones en proceso (para práctica de concurrencia)
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado, descripcion, metodo_pago) VALUES
('PAY_20241106_104_001_P001', 104, 1, 3.25, NOW() - INTERVAL 30 MINUTE, 'PROCESANDO', 'Almuerzo especial', 'QR_SCAN'),
('PAY_20241106_105_003_P002', 105, 3, 7.50, NOW() - INTERVAL 15 MINUTE, 'PROCESANDO', 'Medicamentos recetados', 'QR_SCAN');

-- =====================================================
-- INSERTAR LÍMITES DIARIOS ACTUALES
-- =====================================================

INSERT INTO Limites_Diarios (cliente_id, fecha, monto_acumulado, numero_transacciones) VALUES
(101, CURDATE(), 2.50, 1),
(102, CURDATE(), 0.35, 1),
(103, CURDATE(), 1.75, 1),
(104, CURDATE(), 0.00, 0),  -- Para práctica de primera transacción del día
(105, CURDATE(), 0.00, 0),  -- Para práctica de primera transacción del día
(106, CURDATE(), 0.00, 0),
(107, CURDATE(), 0.00, 0),
(108, CURDATE(), 0.00, 0),
(109, CURDATE(), 0.00, 0),
(110, CURDATE(), 0.00, 0);

-- =====================================================
-- INSERTAR REGISTROS DE AUDITORÍA
-- =====================================================

INSERT INTO Auditoria_Transacciones (payment_id, accion, tabla_afectada, registro_id, usuario_sistema) VALUES
('PAY_20241106_101_001_T001', 'INICIO', 'Pagos_QR', 101, 'SISTEMA_PAGOS'),
('PAY_20241106_101_001_T001', 'DEBITO', 'Cuentas', 101, 'SISTEMA_PAGOS'),
('PAY_20241106_101_001_T001', 'CREDITO', 'Cuentas', 201, 'SISTEMA_PAGOS'),
('PAY_20241106_101_001_T001', 'COMMIT', 'Pagos_QR', 101, 'SISTEMA_PAGOS'),
('PAY_20241106_102_002_T002', 'INICIO', 'Pagos_QR', 102, 'SISTEMA_PAGOS'),
('PAY_20241106_102_002_T002', 'DEBITO', 'Cuentas', 102, 'SISTEMA_PAGOS'),
('PAY_20241106_102_002_T002', 'CREDITO', 'Cuentas', 202, 'SISTEMA_PAGOS'),
('PAY_20241106_102_002_T002', 'COMMIT', 'Pagos_QR', 102, 'SISTEMA_PAGOS');

-- =====================================================
-- CONSULTAS DE VERIFICACIÓN
-- =====================================================

-- Verificar cuentas creadas
SELECT 'CUENTAS CREADAS' AS seccion;
SELECT 
    id,
    titular,
    saldo,
    limite_diario,
    estado,
    CASE 
        WHEN id BETWEEN 101 AND 110 THEN 'CLIENTE'
        WHEN id BETWEEN 201 AND 210 THEN 'COMERCIO'
    END AS tipo
FROM Cuentas 
ORDER BY id;

-- Verificar comercios afiliados
SELECT 'COMERCIOS AFILIADOS' AS seccion;
SELECT 
    c.id,
    c.nombre,
    c.categoria,
    c.ciudad,
    c.estado,
    cu.saldo AS saldo_cuenta
FROM Comercios c
JOIN Cuentas cu ON c.cuenta_bancoloja = cu.id
ORDER BY c.id;

-- Verificar transacciones del día
SELECT 'TRANSACCIONES DEL DÍA' AS seccion;
SELECT 
    p.payment_id,
    c_cliente.titular AS cliente,
    com.nombre AS comercio,
    p.monto,
    p.estado,
    p.descripcion,
    TIME(p.fecha) AS hora
FROM Pagos_QR p
JOIN Cuentas c_cliente ON p.cliente_id = c_cliente.id
JOIN Comercios com ON p.comercio_id = com.id
WHERE DATE(p.fecha) = CURDATE()
ORDER BY p.fecha DESC;

-- Verificar límites diarios
SELECT 'LÍMITES DIARIOS' AS seccion;
SELECT 
    c.titular,
    ld.monto_acumulado,
    c.limite_diario,
    (c.limite_diario - ld.monto_acumulado) AS disponible,
    ld.numero_transacciones
FROM Limites_Diarios ld
JOIN Cuentas c ON ld.cliente_id = c.id
WHERE ld.fecha = CURDATE()
ORDER BY c.titular;

-- =====================================================
-- SCRIPTS DE PRÁCTICA SUGERIDOS
-- =====================================================

SELECT 'SCRIPTS DE PRÁCTICA DISPONIBLES' AS seccion;
SELECT 
    'Para practicar transacciones concurrentes, ejecutar:' AS instruccion,
    '1. Abrir dos sesiones de MySQL Workbench' AS paso_1,
    '2. En ambas sesiones: USE pagos_qr_sistema;' AS paso_2,
    '3. Ejecutar transacciones simultáneas en comercio ID 1 (Restaurante La Casona)' AS paso_3,
    '4. Observar bloqueos y comportamiento de concurrencia' AS paso_4;

-- Ejemplo de transacción para práctica (NO EJECUTAR AUTOMÁTICAMENTE)
/*
-- SESIÓN 1: María José paga $2.50
START TRANSACTION;
SELECT saldo FROM Cuentas WHERE id = 101 FOR UPDATE;
UPDATE Cuentas SET saldo = saldo - 2.50 WHERE id = 101;
UPDATE Cuentas SET saldo = saldo + 2.50 WHERE id = 201;
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, descripcion, estado) 
VALUES ('PAY_20241106_101_001_LAB1', 101, 1, 2.50, 'Práctica Lab 1', 'CONFIRMADO');
-- ESPERAR ANTES DE HACER COMMIT PARA VER BLOQUEOS
COMMIT;

-- SESIÓN 2: Edgar paga $1.25 (ejecutar simultáneamente)
START TRANSACTION;
SELECT saldo FROM Cuentas WHERE id = 102 FOR UPDATE;
UPDATE Cuentas SET saldo = saldo - 1.25 WHERE id = 102;
UPDATE Cuentas SET saldo = saldo + 1.25 WHERE id = 201; -- ¿Espera aquí?
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, descripcion, estado) 
VALUES ('PAY_20241106_102_001_LAB2', 102, 1, 1.25, 'Práctica Lab 2', 'CONFIRMADO');
COMMIT;
*/

-- =====================================================
-- MENSAJE FINAL
-- =====================================================
SELECT 
    'DATOS DE PRÁCTICA INSERTADOS EXITOSAMENTE' AS mensaje,
    '10 cuentas de estudiantes (ID 101-110)' AS clientes,
    '10 cuentas de comercios (ID 201-210)' AS comercios,
    '10 comercios afiliados con QR' AS comercios_qr,
    '20 transacciones históricas + 5 del día actual' AS transacciones,
    'Datos listos para práctica de concurrencia' AS estado;