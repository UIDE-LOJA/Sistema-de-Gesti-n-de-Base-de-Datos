-- =====================================================
-- SCRIPT DE CREACIÓN DE BASE DE DATOS
-- Semana 2: Transacciones y Control de Concurrencia
-- Sistema de Pagos QR "¡ahorita!" - Banco de Loja
-- =====================================================

-- Crear la base de datos
DROP DATABASE IF EXISTS pagos_qr_sistema;
CREATE DATABASE pagos_qr_sistema 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE pagos_qr_sistema;

-- =====================================================
-- TABLA: Cuentas
-- Almacena las cuentas de clientes y comercios
-- =====================================================
CREATE TABLE Cuentas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titular VARCHAR(100) NOT NULL,
    saldo DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    limite_diario DECIMAL(15,2) NOT NULL DEFAULT 100.00,
    estado ENUM('ACTIVA', 'BLOQUEADA') DEFAULT 'ACTIVA',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints de integridad
    CONSTRAINT chk_saldo_positivo CHECK (saldo >= 0),
    CONSTRAINT chk_limite_positivo CHECK (limite_diario > 0),
    
    -- Índices para optimización
    INDEX idx_titular (titular),
    INDEX idx_estado (estado),
    INDEX idx_fecha_creacion (fecha_creacion)
) ENGINE=InnoDB 
  COMMENT='Cuentas de clientes y comercios del sistema de pagos QR';

-- =====================================================
-- TABLA: Comercios
-- Información específica de comercios afiliados
-- =====================================================
CREATE TABLE Comercios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cuenta_bancoloja INT NOT NULL,
    qr_code VARCHAR(255) UNIQUE NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    categoria ENUM('RESTAURANTE', 'TRANSPORTE', 'FARMACIA', 'GASOLINERA', 'CAFETERIA', 'MINIMARKET', 'PANADERIA', 'OTROS') DEFAULT 'OTROS',
    estado ENUM('ACTIVO', 'INACTIVO') DEFAULT 'ACTIVO',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign Key
    FOREIGN KEY (cuenta_bancoloja) REFERENCES Cuentas(id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    
    -- Índices para optimización
    INDEX idx_nombre (nombre),
    INDEX idx_ciudad (ciudad),
    INDEX idx_categoria (categoria),
    INDEX idx_estado (estado),
    INDEX idx_qr_code (qr_code)
) ENGINE=InnoDB 
  COMMENT='Comercios afiliados al sistema de pagos QR';

-- =====================================================
-- TABLA: Pagos_QR
-- Registro de todas las transacciones de pago
-- =====================================================
CREATE TABLE Pagos_QR (
    payment_id VARCHAR(50) PRIMARY KEY,
    cliente_id INT NOT NULL,
    comercio_id INT NOT NULL,
    monto DECIMAL(15,2) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('PROCESANDO', 'CONFIRMADO', 'FALLIDO', 'REVERTIDO') DEFAULT 'PROCESANDO',
    descripcion VARCHAR(200),
    metodo_pago ENUM('QR_SCAN', 'QR_GENERATE', 'NFC') DEFAULT 'QR_SCAN',
    ip_origen VARCHAR(45),
    dispositivo VARCHAR(100),
    
    -- Foreign Keys
    FOREIGN KEY (cliente_id) REFERENCES Cuentas(id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    FOREIGN KEY (comercio_id) REFERENCES Comercios(id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    
    -- Constraints de integridad
    CONSTRAINT chk_monto_positivo CHECK (monto > 0),
    CONSTRAINT chk_payment_id_format CHECK (payment_id REGEXP '^PAY_[0-9]{8}_[0-9]+_[0-9]+_[A-Z0-9]+$'),
    
    -- Índices para optimización y consultas frecuentes
    INDEX idx_cliente_fecha (cliente_id, fecha),
    INDEX idx_comercio_fecha (comercio_id, fecha),
    INDEX idx_estado (estado),
    INDEX idx_fecha (fecha),
    INDEX idx_monto (monto)
) ENGINE=InnoDB 
  COMMENT='Registro de transacciones de pagos QR';

-- =====================================================
-- TABLA: Auditoria_Transacciones
-- Log de auditoría para seguimiento de cambios
-- =====================================================
CREATE TABLE Auditoria_Transacciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id VARCHAR(50) NOT NULL,
    accion ENUM('INICIO', 'DEBITO', 'CREDITO', 'COMMIT', 'ROLLBACK', 'ERROR') NOT NULL,
    tabla_afectada VARCHAR(50),
    registro_id INT,
    valor_anterior TEXT,
    valor_nuevo TEXT,
    usuario_sistema VARCHAR(50) DEFAULT 'SISTEMA_PAGOS',
    timestamp_accion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Key
    FOREIGN KEY (payment_id) REFERENCES Pagos_QR(payment_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    -- Índices
    INDEX idx_payment_id (payment_id),
    INDEX idx_accion (accion),
    INDEX idx_timestamp (timestamp_accion)
) ENGINE=InnoDB 
  COMMENT='Auditoría de transacciones para trazabilidad';

-- =====================================================
-- TABLA: Limites_Diarios
-- Control de límites diarios por cliente
-- =====================================================
CREATE TABLE Limites_Diarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha DATE NOT NULL,
    monto_acumulado DECIMAL(15,2) DEFAULT 0.00,
    numero_transacciones INT DEFAULT 0,
    ultima_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign Key
    FOREIGN KEY (cliente_id) REFERENCES Cuentas(id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    -- Constraint único por cliente y fecha
    UNIQUE KEY uk_cliente_fecha (cliente_id, fecha),
    
    -- Índices
    INDEX idx_fecha (fecha),
    INDEX idx_monto_acumulado (monto_acumulado)
) ENGINE=InnoDB 
  COMMENT='Control de límites diarios de transacciones';

-- =====================================================
-- VISTAS ÚTILES PARA CONSULTAS FRECUENTES
-- =====================================================

-- Vista: Resumen de cuentas con información de comercio
CREATE VIEW v_cuentas_completas AS
SELECT 
    c.id,
    c.titular,
    c.saldo,
    c.limite_diario,
    c.estado,
    c.fecha_creacion,
    CASE 
        WHEN com.id IS NOT NULL THEN 'COMERCIO'
        ELSE 'CLIENTE'
    END AS tipo_cuenta,
    com.nombre AS nombre_comercio,
    com.categoria AS categoria_comercio,
    com.ciudad
FROM Cuentas c
LEFT JOIN Comercios com ON c.id = com.cuenta_bancoloja;

-- Vista: Transacciones del día actual
CREATE VIEW v_transacciones_hoy AS
SELECT 
    p.payment_id,
    p.monto,
    p.estado,
    p.fecha,
    c_cliente.titular AS cliente,
    com.nombre AS comercio,
    com.categoria,
    com.ciudad
FROM Pagos_QR p
JOIN Cuentas c_cliente ON p.cliente_id = c_cliente.id
JOIN Comercios com ON p.comercio_id = com.id
WHERE DATE(p.fecha) = CURDATE()
ORDER BY p.fecha DESC;

-- Vista: Estadísticas por comercio
CREATE VIEW v_estadisticas_comercios AS
SELECT 
    com.id,
    com.nombre,
    com.categoria,
    com.ciudad,
    COUNT(p.payment_id) AS total_transacciones,
    COALESCE(SUM(CASE WHEN p.estado = 'CONFIRMADO' THEN p.monto ELSE 0 END), 0) AS ingresos_confirmados,
    COALESCE(AVG(CASE WHEN p.estado = 'CONFIRMADO' THEN p.monto ELSE NULL END), 0) AS ticket_promedio,
    c.saldo AS saldo_actual
FROM Comercios com
JOIN Cuentas c ON com.cuenta_bancoloja = c.id
LEFT JOIN Pagos_QR p ON com.id = p.comercio_id AND DATE(p.fecha) = CURDATE()
GROUP BY com.id, com.nombre, com.categoria, com.ciudad, c.saldo;

-- =====================================================
-- PROCEDIMIENTOS ALMACENADOS PARA OPERACIONES COMUNES
-- =====================================================

DELIMITER //

-- Procedimiento: Procesar pago QR completo
CREATE PROCEDURE sp_procesar_pago_qr(
    IN p_payment_id VARCHAR(50),
    IN p_cliente_id INT,
    IN p_comercio_id INT,
    IN p_monto DECIMAL(15,2),
    IN p_descripcion VARCHAR(200),
    OUT p_resultado VARCHAR(100)
)
BEGIN
    DECLARE v_saldo_cliente DECIMAL(15,2);
    DECLARE v_limite_diario DECIMAL(15,2);
    DECLARE v_monto_acumulado DECIMAL(15,2) DEFAULT 0;
    DECLARE v_estado_cliente VARCHAR(20);
    DECLARE v_estado_comercio VARCHAR(20);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_resultado = 'ERROR: Transacción fallida';
    END;

    START TRANSACTION;
    
    -- Verificar estado del cliente
    SELECT saldo, limite_diario, estado 
    INTO v_saldo_cliente, v_limite_diario, v_estado_cliente
    FROM Cuentas 
    WHERE id = p_cliente_id FOR UPDATE;
    
    -- Verificar estado del comercio
    SELECT c.estado INTO v_estado_comercio
    FROM Comercios com
    JOIN Cuentas c ON com.cuenta_bancoloja = c.id
    WHERE com.id = p_comercio_id FOR UPDATE;
    
    -- Validaciones
    IF v_estado_cliente != 'ACTIVA' THEN
        SET p_resultado = 'ERROR: Cuenta cliente bloqueada';
        ROLLBACK;
    ELSEIF v_estado_comercio != 'ACTIVA' THEN
        SET p_resultado = 'ERROR: Comercio inactivo';
        ROLLBACK;
    ELSEIF v_saldo_cliente < p_monto THEN
        SET p_resultado = 'ERROR: Saldo insuficiente';
        ROLLBACK;
    ELSE
        -- Verificar límite diario
        SELECT COALESCE(monto_acumulado, 0) INTO v_monto_acumulado
        FROM Limites_Diarios 
        WHERE cliente_id = p_cliente_id AND fecha = CURDATE();
        
        IF (v_monto_acumulado + p_monto) > v_limite_diario THEN
            SET p_resultado = 'ERROR: Límite diario excedido';
            ROLLBACK;
        ELSE
            -- Registrar transacción
            INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, descripcion, estado)
            VALUES (p_payment_id, p_cliente_id, p_comercio_id, p_monto, p_descripcion, 'PROCESANDO');
            
            -- Debitar cliente
            UPDATE Cuentas 
            SET saldo = saldo - p_monto 
            WHERE id = p_cliente_id;
            
            -- Acreditar comercio
            UPDATE Cuentas 
            SET saldo = saldo + p_monto 
            WHERE id = (SELECT cuenta_bancoloja FROM Comercios WHERE id = p_comercio_id);
            
            -- Actualizar límite diario
            INSERT INTO Limites_Diarios (cliente_id, fecha, monto_acumulado, numero_transacciones)
            VALUES (p_cliente_id, CURDATE(), p_monto, 1)
            ON DUPLICATE KEY UPDATE 
                monto_acumulado = monto_acumulado + p_monto,
                numero_transacciones = numero_transacciones + 1;
            
            -- Confirmar transacción
            UPDATE Pagos_QR 
            SET estado = 'CONFIRMADO' 
            WHERE payment_id = p_payment_id;
            
            COMMIT;
            SET p_resultado = 'SUCCESS: Pago procesado exitosamente';
        END IF;
    END IF;
END //

DELIMITER ;

-- =====================================================
-- CONFIGURACIÓN DE VARIABLES DEL SISTEMA
-- =====================================================

-- Configurar timeout para deadlock detection
SET GLOBAL innodb_lock_wait_timeout = 5;
SET GLOBAL innodb_deadlock_detect = ON;

-- Configurar nivel de aislamiento por defecto
SET GLOBAL transaction_isolation = 'REPEATABLE-READ';

-- =====================================================
-- MENSAJE DE CONFIRMACIÓN
-- =====================================================
SELECT 'Base de datos pagos_qr_sistema creada exitosamente' AS mensaje,
       'Tablas: Cuentas, Comercios, Pagos_QR, Auditoria_Transacciones, Limites_Diarios' AS tablas_creadas,
       'Vistas: v_cuentas_completas, v_transacciones_hoy, v_estadisticas_comercios' AS vistas_creadas,
       'Procedimiento: sp_procesar_pago_qr' AS procedimientos_creados;