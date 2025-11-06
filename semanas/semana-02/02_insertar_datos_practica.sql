-- =====================================================
-- SCRIPT DE INSERCIÓN DE DATOS DE PRÁCTICA
-- Semana 2: Transacciones y Control de Concurrencia
-- Sistema de Pagos QR "¡ahorita!" - Banco de Loja
-- Contexto real: Loja - Ecuador
-- =====================================================
-- NOTA: Este script es IDEMPOTENTE (se puede ejecutar múltiples veces)
-- Usa INSERT IGNORE para evitar errores de duplicados
-- =====================================================

USE pagos_qr_sistema;

-- =====================================================
-- INSERTAR CUENTAS DE ESTUDIANTES (CLIENTES UIDE LOJA)
-- =====================================================

INSERT IGNORE INTO Cuentas (id, titular, saldo, limite_diario, estado) VALUES
(101, 'EDGAR ANDERSON BUSTOS CASTILLO',        25.00,  80.00, 'ACTIVA'),
(102, 'HECTOR ANTONIO CAMPOVERDE RODRIGUEZ',   18.75,  60.00, 'ACTIVA'),
(103, 'ANYELA CAROLINA CARPIO TORRES',         32.50,  80.00, 'ACTIVA'),
(104, 'CARLO SEBASTIÁN CARRION ESPINOSA',      45.00, 100.00, 'ACTIVA'),
(105, 'JOSEPH STEVEN CARTUCHE VICENTE',        12.25,  50.00, 'ACTIVA'),
(106, 'STEVEN PAUL CHINININ CAMACAS',          28.00,  70.00, 'ACTIVA'),
(107, 'STEPHANO DILAN GALVEZ PEREZ',           22.75,  60.00, 'ACTIVA'),
(108, 'DAVID ALEJANDRO GARCIA ROJAS',          35.50,  90.00, 'ACTIVA'),
(109, 'KEVIN MICHAEL GIRON CHUQUIRIMA',        19.25,  60.00, 'ACTIVA'),
(110, 'GEOVANNY ALEXANDER GUAMAN ALVARADO',    41.00,  90.00, 'ACTIVA'),
(111, 'MARIA JOSE GUANCA GUAMAN',              27.40,  70.00, 'ACTIVA'),
(112, 'CESAR YEHIDYNG JARAMILLO JUNGAL',       26.10,  70.00, 'ACTIVA'),
(113, 'DIEGO FERNANDO LOPEZ SAQUICELA',        33.80,  80.00, 'ACTIVA'),
(114, 'DEYVI HERNAN MASACHE RENGEL',           21.90,  60.00, 'ACTIVA'),
(115, 'JANNETH NAYERLY MEDINA CAMBISACA',      29.70,  70.00, 'ACTIVA'),
(116, 'ANGEL FERNANDO MEDINA MENDOZA',         24.60,  60.00, 'ACTIVA'),
(117, 'ALEJANDRO DAVID MOROCHO GRAGEDA',       30.25,  80.00, 'ACTIVA'),
(118, 'MILENA YAMILETH ORDOÑEZ LEON',          23.35,  60.00, 'ACTIVA'),
(119, 'LORENA GABRIELA RAMIREZ SARANGO',       26.50,  70.00, 'ACTIVA'),
(120, 'SANTIAGO ALEXANDER RIOS RIOS',          20.15,  60.00, 'ACTIVA'),
(121, 'FELIX AGUSTIN RODAS MELGAR',            22.80,  60.00, 'ACTIVA'),
(122, 'PAULA ALEJANDRA ROJAS GRANDA',          27.90,  70.00, 'ACTIVA'),
(123, 'YOSTIN DANIEL RUIZ SINCHE',             19.80,  50.00, 'ACTIVA'),
(124, 'DERKY ALEJANDRO SANCHEZ GRANDA',        24.10,  60.00, 'ACTIVA'),
(125, 'JHOSTY JHAIR SOTO LEON',                21.75,  60.00, 'ACTIVA'),
(126, 'IRVIN RENE VALLEJO LUDEÑA',             18.90,  50.00, 'ACTIVA'),
(127, 'AURORA MARINA ZHUMA JARAMILLO',         23.60,  60.00, 'ACTIVA'),
(128, 'CHARLIE ALEXANDER CARDENAS TOLEDO',     90.00, 150.00, 'ACTIVA'); -- Profesor / usuario avanzado

-- =====================================================
-- INSERTAR CUENTAS DE COMERCIOS (ECUADOR / LOJA)
-- =====================================================
-- Comercios asociados a Banco de Loja y entorno local

INSERT IGNORE INTO Cuentas (id, titular, saldo, limite_diario, estado) VALUES
(201, 'Cooperativa de Transportes Loja',          450.00, 3000.00, 'ACTIVA'),
(202, 'Cafetería UIDE Campus Loja',               320.75, 1500.00, 'ACTIVA'),
(203, 'Farmacia San Agustín Loja Centro',         275.50, 2000.00, 'ACTIVA'),
(204, 'Gasolinera Primax Pío Jaramillo Loja',    1250.00, 4000.00, 'ACTIVA'),
(205, 'Farmacia Cruz Azul Loja',                  180.25, 2000.00, 'ACTIVA'),
(206, 'Minimarket Don Pepe Loja',                 380.00, 1500.00, 'ACTIVA'),
(207, 'Panadería El Molino Loja',                 195.75, 1000.00, 'ACTIVA'),
(208, 'Transporte Urbano Loja',                   145.50, 1200.00, 'ACTIVA'),
(209, 'Cafetería Central Park Loja',              220.00, 1500.00, 'ACTIVA'),
(210, 'Restaurante El Buen Sabor Loja',           165.25, 1500.00, 'ACTIVA');

-- =====================================================
-- INSERTAR COMERCIOS AFILIADOS "¡ahorita!" BANCO DE LOJA
-- =====================================================

INSERT IGNORE INTO Comercios (id, nombre, cuenta_bancoloja, qr_code, ciudad, categoria, estado) VALUES
(1,  'Cooperativa de Transportes Loja',       201, 'QR_COOP_LOJA_2024_001',     'Loja',       'TRANSPORTE', 'ACTIVO'),
(2,  'Cafetería UIDE Campus Loja',            202, 'QR_CAF_UIDE_LOJA_2024_002','Loja',       'CAFETERIA',  'ACTIVO'),
(3,  'Farmacia San Agustín Loja Centro',      203, 'QR_FARM_SANAG_2024_003',   'Loja',       'FARMACIA',   'ACTIVO'),
(4,  'Gasolinera Primax Pío Jaramillo',       204, 'QR_PRIMAX_PJ_2024_004',    'Loja',       'GASOLINERA', 'ACTIVO'),
(5,  'Farmacia Cruz Azul Loja',               205, 'QR_FARM_CRUZAZUL_2024_005','Loja',       'FARMACIA',   'ACTIVO'),
(6,  'Minimarket Don Pepe Loja',              206, 'QR_MINI_DONPEPE_2024_006', 'Loja',       'MINIMARKET', 'ACTIVO'),
(7,  'Panadería El Molino Loja',              207, 'QR_PAN_MOLINO_2024_007',   'Loja',       'PANADERIA',  'ACTIVO'),
(8,  'Transporte Urbano Loja',                208, 'QR_TRANS_URB_LOJA_2024_008','Loja',      'TRANSPORTE', 'ACTIVO'),
(9,  'Cafetería Central Park Loja',           209, 'QR_CAF_PARK_2024_009',     'Loja',       'CAFETERIA',  'ACTIVO'),
(10, 'Restaurante El Buen Sabor Loja',        210, 'QR_REST_BUENSABOR_2024_010','Loja',      'RESTAURANTE','ACTIVO');

-- =====================================================
-- INSERTAR TRANSACCIONES HISTÓRICAS (ÚLTIMOS 3 DÍAS)
-- Fechas simuladas 2024-11-03 / 04 / 05
-- =====================================================

-- Hace 3 días
INSERT IGNORE INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado, descripcion, metodo_pago) VALUES
('PAY_20241103_101_001_H001', 101, 1,  18.00, '2024-11-03 06:30:15', 'CONFIRMADO', 'Pasaje Loja-Quito Coop. Loja',                'QR_AHORITA'),
('PAY_20241103_102_002_H002', 102, 2,   2.50, '2024-11-03 09:10:22', 'CONFIRMADO', 'Desayuno en Cafetería UIDE',                 'QR_AHORITA'),
('PAY_20241103_103_003_H003', 103, 3,   7.80, '2024-11-03 11:45:10', 'CONFIRMADO', 'Medicamentos Farmacia San Agustín',          'QR_AHORITA'),
('PAY_20241103_104_004_H004', 104, 4,  15.00, '2024-11-03 18:15:45', 'CONFIRMADO', 'Carga gasolina Primax Pío Jaramillo',        'QR_AHORITA'),
('PAY_20241103_105_005_H005', 105, 5,   4.20, '2024-11-03 20:30:30', 'CONFIRMADO', 'Medicamentos Farmacia Cruz Azul',            'QR_AHORITA');

-- Hace 2 días
INSERT IGNORE INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado, descripcion, metodo_pago) VALUES
('PAY_20241104_106_002_H006', 106, 2,   3.00, '2024-11-04 12:15:20', 'CONFIRMADO', 'Almuerzo UIDE Campus Loja',                 'QR_AHORITA'),
('PAY_20241104_107_008_H007', 107, 8,   0.35, '2024-11-04 08:20:15', 'CONFIRMADO', 'Pasaje urbano Loja',                         'QR_AHORITA'),
('PAY_20241104_108_010_H008', 108,10,   6.50, '2024-11-04 19:30:45', 'CONFIRMADO', 'Cena Restaurant El Buen Sabor',              'QR_AHORITA'),
('PAY_20241104_109_006_H009', 109, 6,   2.75, '2024-11-04 10:45:30', 'CONFIRMADO', 'Compras Minimarket Don Pepe',                'QR_AHORITA'),
('PAY_20241104_110_007_H010', 110, 7,   1.50, '2024-11-04 16:10:25', 'CONFIRMADO', 'Panadería El Molino - refrigerio',           'QR_AHORITA');

-- Hace 1 día
INSERT IGNORE INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado, descripcion, metodo_pago) VALUES
('PAY_20241105_101_002_H011', 101, 2,   2.80, '2024-11-05 09:15:10', 'CONFIRMADO', 'Café y sándwich en Cafetería UIDE',         'QR_AHORITA'),
('PAY_20241105_102_008_H012', 102, 8,   0.40, '2024-11-05 17:30:20', 'CONFIRMADO', 'Pasaje urbano tarde',                        'QR_AHORITA'),
('PAY_20241105_103_003_H013', 103, 3,   3.25, '2024-11-05 20:45:15', 'CONFIRMADO', 'Compra rápida farmacia',                     'QR_AHORITA'),
('PAY_20241105_104_001_H014', 104, 1,  18.00, '2024-11-05 07:20:30', 'CONFIRMADO', 'Pasaje Coop. Loja Loja-Quito',               'QR_AHORITA'),
('PAY_20241105_105_006_H015', 105, 6,   5.10, '2024-11-05 14:10:45', 'CONFIRMADO', 'Snacks Minimarket Don Pepe',                 'QR_AHORITA');

-- =====================================================
-- TRANSACCIONES DEL DÍA ACTUAL (PRÁCTICA CONCURRENCIA)
-- =====================================================

-- Completadas hoy
INSERT IGNORE INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado, descripcion, metodo_pago) VALUES
('PAY_20241106_101_002_T001', 101, 2,  2.50, NOW() - INTERVAL 2 HOUR, 'CONFIRMADO', 'Almuerzo del día Cafetería UIDE',       'QR_AHORITA'),
('PAY_20241106_102_008_T002', 102, 8,  0.35, NOW() - INTERVAL 3 HOUR, 'CONFIRMADO', 'Pasaje matutino Urbano Loja',          'QR_AHORITA'),
('PAY_20241106_103_005_T003', 103, 5,  1.75, NOW() - INTERVAL 1 HOUR, 'CONFIRMADO', 'Compra Farmacia Cruz Azul',           'QR_AHORITA');

-- En proceso (para ver bloqueos / estados)
INSERT IGNORE INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado, descripcion, metodo_pago) VALUES
('PAY_20241106_104_002_P001', 104, 2,  3.25, NOW() - INTERVAL 30 MINUTE, 'PROCESANDO', 'Almuerzo especial Cafetería UIDE', 'QR_AHORITA'),
('PAY_20241106_105_003_P002', 105, 3,  7.50, NOW() - INTERVAL 15 MINUTE, 'PROCESANDO', 'Medicamentos recetados',          'QR_AHORITA');

-- =====================================================
-- INSERTAR LÍMITES DIARIOS ACTUALES (ENFOQUE EN 101-110)
-- =====================================================

INSERT IGNORE INTO Limites_Diarios (cliente_id, fecha, monto_acumulado, numero_transacciones) VALUES
(101, CURDATE(), 2.50, 1),
(102, CURDATE(), 0.35, 1),
(103, CURDATE(), 1.75, 1),
(104, CURDATE(), 0.00, 0),
(105, CURDATE(), 0.00, 0),
(106, CURDATE(), 0.00, 0),
(107, CURDATE(), 0.00, 0),
(108, CURDATE(), 0.00, 0),
(109, CURDATE(), 0.00, 0),
(110, CURDATE(), 0.00, 0);

-- =====================================================
-- INSERTAR REGISTROS DE AUDITORÍA (EJEMPLOS)
-- =====================================================

INSERT IGNORE INTO Auditoria_Transacciones (payment_id, accion, tabla_afectada, registro_id, usuario_sistema) VALUES
('PAY_20241106_101_002_T001', 'INICIO',  'Pagos_QR', 101, 'SISTEMA_PAGOS'),
('PAY_20241106_101_002_T001', 'DEBITO',  'Cuentas', 101, 'SISTEMA_PAGOS'),
('PAY_20241106_101_002_T001', 'CREDITO', 'Cuentas', 202, 'SISTEMA_PAGOS'),
('PAY_20241106_101_002_T001', 'COMMIT',  'Pagos_QR', 101, 'SISTEMA_PAGOS'),
('PAY_20241106_102_008_T002', 'INICIO',  'Pagos_QR', 102, 'SISTEMA_PAGOS'),
('PAY_20241106_102_008_T002', 'DEBITO',  'Cuentas', 102, 'SISTEMA_PAGOS'),
('PAY_20241106_102_008_T002', 'CREDITO', 'Cuentas', 208, 'SISTEMA_PAGOS'),
('PAY_20241106_102_008_T002', 'COMMIT',  'Pagos_QR', 102, 'SISTEMA_PAGOS');

-- =====================================================
-- CONSULTAS DE VERIFICACIÓN
-- =====================================================

SELECT 'CUENTAS CREADAS' AS seccion;
SELECT 
    id,
    titular,
    saldo,
    limite_diario,
    estado,
    CASE 
        WHEN id BETWEEN 101 AND 199 THEN 'CLIENTE_UIDE_LOJA'
        WHEN id BETWEEN 201 AND 299 THEN 'COMERCIO'
    END AS tipo
FROM Cuentas
ORDER BY id;

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

SELECT 'TRANSACCIONES DEL DÍA' AS seccion;
SELECT 
    p.payment_id,
    c_cliente.titular AS cliente,
    com.nombre       AS comercio,
    p.monto,
    p.estado,
    p.descripcion,
    TIME(p.fecha)    AS hora
FROM Pagos_QR p
JOIN Cuentas   c_cliente ON p.cliente_id  = c_cliente.id
JOIN Comercios com       ON p.comercio_id = com.id
WHERE DATE(p.fecha) = CURDATE()
ORDER BY p.fecha DESC;

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
-- SCRIPTS DE PRÁCTICA SUGERIDOS (CONCURRENCIA)
-- =====================================================

SELECT 'SCRIPTS DE PRÁCTICA DISPONIBLES' AS seccion;
SELECT 
    'Para practicar transacciones concurrentes, ejecutar:'        AS instruccion,
    '1. Abrir dos sesiones de MySQL Workbench'                   AS paso_1,
    '2. En ambas sesiones: USE pagos_qr_sistema;'                AS paso_2,
    '3. Ejecutar pagos simultáneos en Cafetería UIDE (ID 2)'     AS paso_3,
    '4. Observar bloqueos, aislamiento y comportamiento ACID'    AS paso_4;

-- Ejemplo (comentado)
/*
START TRANSACTION;
SELECT saldo FROM Cuentas WHERE id = 101 FOR UPDATE;
UPDATE Cuentas SET saldo = saldo - 2.50 WHERE id = 101;
UPDATE Cuentas SET saldo = saldo + 2.50 WHERE id = 202;
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, descripcion, estado) 
VALUES ('PAY_20241106_101_002_LAB1', 101, 2, 2.50, 'Práctica Lab 1 Cafetería UIDE', 'PENDIENTE');
-- Esperar antes de COMMIT para visualizar bloqueos
COMMIT;
*/

-- =====================================================
-- MENSAJE FINAL
-- =====================================================

SELECT 
    'DATOS DE PRÁCTICA INSERTADOS EXITOSAMENTE'      AS mensaje,
    '28+1 cuentas UIDE Loja (ID 101-128)'           AS clientes,
    '10 cuentas de comercios locales (ID 201-210)'  AS comercios,
    '10 comercios afiliados con QR ¡ahorita!'       AS comercios_qr,
    '15 transacciones históricas + 5 del día actual'AS transacciones,
    'Escenario realista Banco de Loja / Loja-Ecuador listo' AS estado;
