-- =====================================================
-- LABORATORIO SEMANA 3: LOGGING Y RECUPERACIÓN
-- Sistemas de Gestión de Base de Datos
-- Caso de Uso: Sistema de Pagos QR "¡ahorita!" - Banco de Loja
-- =====================================================
-- Objetivo: Comprender y monitorear el funcionamiento de:
-- - InnoDB Redo Log (Write-Ahead Logging)
-- - Checkpoints automáticos
-- - Crash Recovery (ARIES en InnoDB)
-- =====================================================

-- =====================================================
-- INSTRUCCIONES GENERALES DE EJECUCIÓN
-- =====================================================
-- DÓNDE EJECUTAR: MySQL Workbench, cliente MySQL o consola mysql
-- CÓMO EJECUTAR:
--   1. Abrir este archivo en MySQL Workbench
--   2. Conectarse a su instancia de MySQL
--   3. Ejecutar sección por sección (NO todo de una vez)
--   4. Leer los comentarios y anotar resultados
--
-- IMPORTANTE:
--   - Algunos comandos requieren ejecución MANUAL en la consola
--   - Cuando vea "EJECUTAR MANUALMENTE", copiar el comando
--   - Esperar y observar resultados antes de continuar
-- =====================================================

USE pagos_qr_sistema;

-- =====================================================
-- PARTE 1: VERIFICAR CONFIGURACIÓN DE LOGGING
-- =====================================================
-- EJECUTAR EN: MySQL Workbench o cliente MySQL
-- INSTRUCCIÓN: Seleccionar y ejecutar todo el bloque de PARTE 1
-- =====================================================

SELECT '===== PARTE 1: CONFIGURACIÓN ACTUAL DE INNODB LOGGING =====' AS seccion;

-- Ver configuración del Redo Log
-- EJECUTAR: Este comando muestra todas las variables de InnoDB Log
-- Para MySQL 8.0.30+
SHOW VARIABLES LIKE 'innodb_redo_log%';
-- Para MySQL 8.0.29 y anteriores
SHOW VARIABLES LIKE 'innodb_log%';

-- ANOTAR: Los siguientes valores importantes:
--   MySQL 8.0.30+:
--     - innodb_redo_log_capacity: Capacidad total del Redo Log
--   MySQL 8.0.29 y anteriores:
--     - innodb_log_file_size: Tamaño de cada archivo de Redo Log (DEPRECADO)
--     - innodb_log_files_in_group: Número de archivos (DEPRECADO)
--   Todas las versiones:
--     - innodb_log_buffer_size: Buffer en memoria para Redo Log

-- Variables críticas para durabilidad (compatible con todas las versiones)
SELECT
    '1. innodb_flush_log_at_trx_commit' AS variable,
    @@innodb_flush_log_at_trx_commit AS valor_actual,
    'Debe ser 1 para máxima durabilidad' AS recomendacion
UNION ALL
SELECT
    '2. innodb_log_buffer_size',
    @@innodb_log_buffer_size,
    'Buffer en memoria para Redo Log'
UNION ALL
SELECT
    '3. VERSION()',
    VERSION(),
    'Versión de MySQL (8.0.30+ usa innodb_redo_log_capacity)';

-- VERIFICAR: Si innodb_flush_log_at_trx_commit NO es 1:
-- CAMBIAR TEMPORALMENTE (solo para esta sesión):
-- SET GLOBAL innodb_flush_log_at_trx_commit = 1;

-- =====================================================
-- PARTE 2: MONITOREAR ESTADO INICIAL DEL REDO LOG
-- =====================================================
-- EJECUTAR EN: Consola MySQL (mysql -u root -p)
-- INSTRUCCIÓN: Copiar y ejecutar cada comando MANUALMENTE
-- =====================================================

SELECT '===== PARTE 2: ESTADO INICIAL DEL REDO LOG =====' AS seccion;

-- *** EJECUTAR MANUALMENTE EN CONSOLA ***
-- Comando: SHOW ENGINE INNODB STATUS\G
--
-- INSTRUCCIONES:
-- 1. Abrir terminal/CMD
-- 2. Conectarse: mysql -u root -p
-- 3. Ejecutar: USE pagos_qr_sistema;
-- 4. Ejecutar: SHOW ENGINE INNODB STATUS\G
-- 5. BUSCAR la sección "LOG" (aproximadamente línea 30-50)
-- 6. ANOTAR estos valores:
--    a) Log sequence number: ___________________ (LSN actual)
--    b) Last checkpoint at:  ___________________ (Último checkpoint)
--    c) Checkpoint age:      ___________________ (LSN - Checkpoint)
--
-- EJEMPLO de salida:
-- ---
-- LOG
-- ---
-- Log sequence number          123456789
-- Log buffer assigned up to    123456789
-- Log buffer completed up to   123456789
-- Log written up to            123456789
-- Log flushed up to            123456789
-- Added dirty pages up to      123456789
-- Pages flushed up to          123456789
-- Last checkpoint at           123450000
-- =====================================================

-- Ver estado del Buffer Pool (dirty pages)
-- EJECUTAR EN: MySQL Workbench
SHOW STATUS LIKE 'Innodb_buffer_pool_pages%';

-- ANOTAR: Páginas sucias actuales
-- EJECUTAR EN: MySQL Workbench
SELECT
    variable_name,
    variable_value
FROM performance_schema.global_status
WHERE variable_name IN (
    'Innodb_buffer_pool_pages_dirty',
    'Innodb_buffer_pool_pages_total',
    'Innodb_buffer_pool_pages_data'
);

-- ANOTAR RESULTADOS:
-- Innodb_buffer_pool_pages_dirty (ANTES): ___________________
-- Innodb_buffer_pool_pages_total:        ___________________

-- =====================================================
-- PARTE 3: EJECUTAR TRANSACCIONES Y OBSERVAR LOGGING
-- =====================================================
-- EJECUTAR EN: MySQL Workbench
-- INSTRUCCIÓN: Ejecutar cada transacción POR SEPARADO
-- =====================================================

SELECT '===== PARTE 3: EJECUTAR TRANSACCIONES DE PAGO =====' AS seccion;

-- Verificar saldos antes de las transacciones
-- EJECUTAR: Este SELECT primero
SELECT
    'SALDOS INICIALES' AS momento,
    c.id,
    c.titular,
    c.saldo
FROM Cuentas c
WHERE c.id IN (101, 102, 103, 202, 209)
ORDER BY c.id;

-- ANOTAR SALDOS INICIALES:
-- Edgar (101):         ___________________
-- Anyela (103):        ___________________
-- Cafetería UIDE (202):___________________

-- =====================================================
-- TRANSACCIÓN 1: Pago de Edgar en Cafetería UIDE
-- =====================================================
-- EJECUTAR: Seleccionar TODO el bloque hasta COMMIT
-- IMPORTANTE: Ejecutar como UN SOLO BLOQUE
-- =====================================================

START TRANSACTION;

-- Registrar en auditoría el inicio
INSERT INTO Auditoria_Transacciones (payment_id, accion, tabla_afectada, usuario_sistema)
VALUES ('PAY_LAB3_001', 'INICIO', 'Pagos_QR', 'LAB_SEMANA3');

-- Débito cliente Edgar (ID 101)
UPDATE Cuentas
SET saldo = saldo - 2.50
WHERE id = 101;

-- Crédito comercio Cafetería UIDE (ID 202)
UPDATE Cuentas
SET saldo = saldo + 2.50
WHERE id = 202;

-- Registrar transacción en Pagos_QR
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, descripcion, estado, metodo_pago)
VALUES (
    'PAY_LAB3_001',
    101,
    2,
    2.50,
    'Lab Semana 3 - Pago Edgar en Cafetería UIDE',
    'CONFIRMADO',
    'QR_AHORITA'
);

-- Registrar commit en auditoría
INSERT INTO Auditoria_Transacciones (payment_id, accion, tabla_afectada, usuario_sistema)
VALUES ('PAY_LAB3_001', 'COMMIT', 'Pagos_QR', 'LAB_SEMANA3');

COMMIT;
-- *** IMPORTANTE ***
-- Al ejecutar COMMIT, InnoDB:
-- 1. Escribe los cambios al Redo Log (WAL)
-- 2. Flush al disco (si innodb_flush_log_at_trx_commit = 1)
-- 3. LUEGO confirma la transacción
-- =====================================================

SELECT 'Transacción 1 completada - Verificar LSN incrementado' AS resultado;

-- *** AHORA VERIFICAR CAMBIO EN LSN ***
-- EJECUTAR MANUALMENTE EN CONSOLA:
-- SHOW ENGINE INNODB STATUS\G
--
-- COMPARAR con valores anotados en PARTE 2:
-- Log sequence number AHORA: ___________________ (debe ser mayor)
-- Incremento:                ___________________ (LSN nuevo - LSN viejo)
-- =====================================================

-- =====================================================
-- TRANSACCIÓN 2: Pago de Anyela en Cafetería Central Park
-- =====================================================
-- EJECUTAR: Seleccionar TODO el bloque hasta COMMIT
-- =====================================================

START TRANSACTION;

INSERT INTO Auditoria_Transacciones (payment_id, accion, tabla_afectada, usuario_sistema)
VALUES ('PAY_LAB3_002', 'INICIO', 'Pagos_QR', 'LAB_SEMANA3');

UPDATE Cuentas SET saldo = saldo - 3.75 WHERE id = 103;
UPDATE Cuentas SET saldo = saldo + 3.75 WHERE id = 209;

INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, descripcion, estado, metodo_pago)
VALUES (
    'PAY_LAB3_002',
    103,
    9,
    3.75,
    'Lab Semana 3 - Pago Anyela en Central Park',
    'CONFIRMADO',
    'QR_AHORITA'
);

INSERT INTO Auditoria_Transacciones (payment_id, accion, tabla_afectada, usuario_sistema)
VALUES ('PAY_LAB3_002', 'COMMIT', 'Pagos_QR', 'LAB_SEMANA3');

COMMIT;

SELECT 'Transacción 2 completada' AS resultado;

-- =====================================================
-- PARTE 4: VERIFICAR CAMBIOS EN EL REDO LOG
-- =====================================================
-- EJECUTAR EN: MySQL Workbench
-- =====================================================

SELECT '===== PARTE 4: MONITOREO POST-TRANSACCIONES =====' AS seccion;

-- Instrucciones para verificar manualmente
SELECT
    'Ejecutar nuevamente: SHOW ENGINE INNODB STATUS\\G' AS instruccion,
    'Comparar con valores iniciales:' AS paso_1,
    '1. Log sequence number debe haber incrementado' AS observacion_1,
    '2. Innodb_os_log_written aumenta en bytes' AS observacion_2,
    '3. Last checkpoint at puede cambiar si hubo checkpoint' AS observacion_3;

-- Ver bytes escritos al log
SHOW STATUS LIKE 'Innodb_os_log_written';

-- ANOTAR: Bytes escritos al log: ___________________

-- Ver operaciones de log
SHOW STATUS LIKE 'Innodb_log_write%';

-- ANOTAR:
-- Innodb_log_writes:       ___________________ (número de escrituras)
-- Innodb_log_write_requests: ___________________ (solicitudes)

-- Verificar saldos después de las transacciones
SELECT
    'SALDOS DESPUÉS DE TRANSACCIONES' AS momento,
    c.id,
    c.titular,
    c.saldo,
    'Cambios confirmados y durables' AS garantia
FROM Cuentas c
WHERE c.id IN (101, 102, 103, 202, 209)
ORDER BY c.id;

-- VERIFICAR:
-- ¿Los saldos cambiaron correctamente?
-- ¿Se aplicaron todas las transacciones?

-- =====================================================
-- PARTE 5: GENERAR MÚLTIPLES TRANSACCIONES PARA CHECKPOINT
-- =====================================================
-- EJECUTAR EN: MySQL Workbench
-- OBJETIVO: Generar suficiente actividad para provocar un checkpoint
-- =====================================================

SELECT '===== PARTE 5: GENERAR CARGA PARA OBSERVAR CHECKPOINT =====' AS seccion;

-- PASO 1: Crear procedimiento almacenado
-- EJECUTAR: Todo el bloque DELIMITER hasta el segundo DELIMITER
DELIMITER //

DROP PROCEDURE IF EXISTS sp_generar_carga_log;
CREATE PROCEDURE sp_generar_carga_log()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE payment_id_var VARCHAR(50);

    WHILE i <= 20 DO
        SET payment_id_var = CONCAT('PAY_LAB3_CARGA_', LPAD(i, 3, '0'));

        START TRANSACTION;

        -- Simular pago de Carlo (104) en diferentes comercios
        UPDATE Cuentas SET saldo = saldo - 1.00 WHERE id = 104;
        UPDATE Cuentas SET saldo = saldo + 1.00 WHERE id = 202;

        INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, descripcion, estado, metodo_pago)
        VALUES (
            payment_id_var,
            104,
            2,
            1.00,
            CONCAT('Carga Lab 3 - Transacción ', i),
            'CONFIRMADO',
            'QR_AHORITA'
        );

        COMMIT;

        SET i = i + 1;
    END WHILE;

    SELECT '20 transacciones generadas para provocar checkpoint' AS resultado;
END //

DELIMITER ;

-- PASO 2: Ejecutar el procedimiento
-- EJECUTAR: Solo esta línea
CALL sp_generar_carga_log();

-- OBSERVAR: Debe mostrar "20 transacciones generadas..."

-- PASO 3: Ver dirty pages después de la carga
SELECT
    'DESPUÉS DE GENERAR CARGA' AS momento,
    variable_name,
    variable_value
FROM performance_schema.global_status
WHERE variable_name LIKE 'Innodb_buffer_pool_pages_dirty';

-- ANOTAR:
-- Innodb_buffer_pool_pages_dirty (DESPUÉS): ___________________
-- ¿Aumentó respecto al valor inicial?

-- PASO 4: Verificar si hubo checkpoint
-- EJECUTAR MANUALMENTE EN CONSOLA:
-- SHOW ENGINE INNODB STATUS\G
--
-- VERIFICAR:
-- ¿Cambió "Last checkpoint at"?
-- ¿Se redujo el "Checkpoint age"?

-- =====================================================
-- PARTE 6: SIMULACIÓN DE CRASH Y RECUPERACIÓN
-- =====================================================
-- EJECUTAR EN: MySQL Workbench
-- ADVERTENCIA: Esta parte simula un crash
-- =====================================================

SELECT '===== PARTE 6: SIMULACIÓN DE CRASH RECOVERY =====' AS seccion;

SELECT
    'ESCENARIO DE CRASH RECOVERY' AS titulo,
    '1. Ejecutar transacción sin COMMIT' AS paso_1,
    '2. Simular crash (cerrar servidor forzadamente)' AS paso_2,
    '3. Al reiniciar, InnoDB ejecuta ARIES:' AS paso_3,
    '   - REDO: Reaplica cambios confirmados desde checkpoint' AS redo_phase,
    '   - UNDO: Revierte transacciones no confirmadas' AS undo_phase;

-- =====================================================
-- EXPERIMENTO: Transacción sin COMMIT
-- =====================================================
-- INSTRUCCIONES:
-- 1. EJECUTAR el siguiente START TRANSACTION
-- 2. NO ejecutar COMMIT
-- 3. Observar qué pasa al hacer ROLLBACK
-- =====================================================

-- PASO 1: Iniciar transacción
START TRANSACTION;

-- PASO 2: Modificar datos
UPDATE Cuentas SET saldo = saldo - 5.00 WHERE id = 105;

-- PASO 3: Verificar cambio (solo en esta sesión)
SELECT
    'DENTRO DE LA TRANSACCIÓN' AS momento,
    id,
    titular,
    saldo
FROM Cuentas
WHERE id = 105;

-- OBSERVAR: El saldo cambió temporalmente

SELECT
    'Transacción iniciada pero SIN COMMIT' AS estado,
    'Si crasheara ahora, se revertiría automáticamente' AS comportamiento;

-- *** IMPORTANTE ***
-- En una situación real de crash:
-- 1. Esta transacción NO está en el Redo Log (sin COMMIT)
-- 2. Solo existe en el Buffer Pool (memoria)
-- 3. Al reiniciar, InnoDB la descartará (UNDO)
-- =====================================================

-- PASO 4: Revertir la transacción
ROLLBACK;

SELECT 'ROLLBACK ejecutado - transacción revertida' AS resultado;

-- PASO 5: Verificar que se revirtió
SELECT
    'DESPUÉS DE ROLLBACK' AS momento,
    id,
    titular,
    saldo
FROM Cuentas
WHERE id = 105;

-- VERIFICAR: El saldo volvió a su valor original

-- =====================================================
-- PARTE 7: ANÁLISIS DE AUDITORÍA
-- =====================================================
-- EJECUTAR EN: MySQL Workbench
-- =====================================================

SELECT '===== PARTE 7: VERIFICAR AUDITORÍA DE TRANSACCIONES =====' AS seccion;

-- Ver todas las acciones registradas en el laboratorio
SELECT
    id,
    payment_id,
    accion,
    tabla_afectada,
    timestamp_accion,
    CONCAT('T+', TIMESTAMPDIFF(SECOND, MIN(timestamp_accion) OVER(), timestamp_accion), 's') AS tiempo_relativo
FROM Auditoria_Transacciones
WHERE payment_id LIKE 'PAY_LAB3%'
ORDER BY timestamp_accion;

-- OBSERVAR:
-- ¿Cuántas acciones INICIO vs COMMIT?
-- ¿Hay algún INICIO sin COMMIT?

-- Verificar integridad del sistema
SELECT
    'VERIFICACIÓN DE INTEGRIDAD' AS titulo,
    (SELECT COUNT(*) FROM Pagos_QR WHERE payment_id LIKE 'PAY_LAB3%') AS total_pagos_lab,
    (SELECT SUM(monto) FROM Pagos_QR WHERE payment_id LIKE 'PAY_LAB3%' AND estado = 'CONFIRMADO') AS monto_total_confirmado,
    (SELECT COUNT(*) FROM Auditoria_Transacciones WHERE payment_id LIKE 'PAY_LAB3%' AND accion = 'COMMIT') AS commits_registrados;

-- ANOTAR:
-- Total de pagos realizados:    ___________________
-- Monto total confirmado:       ___________________
-- Commits registrados:          ___________________

-- =====================================================
-- PARTE 8: PREGUNTAS DE REFLEXIÓN
-- =====================================================
-- NO EJECUTAR - Solo leer y responder en informe
-- =====================================================

SELECT '===== PARTE 8: PREGUNTAS PARA REFLEXIÓN =====' AS seccion;

SELECT
    '1. ¿Cuánto incrementó el Log Sequence Number?' AS pregunta_1,
    '2. ¿Se generó algún checkpoint automático durante las transacciones?' AS pregunta_2,
    '3. ¿Qué sucedería si innodb_flush_log_at_trx_commit fuera 0?' AS pregunta_3,
    '4. ¿Cómo afecta el tamaño del Redo Log al rendimiento?' AS pregunta_4,
    '5. ¿Qué garantías ACID se cumplen gracias al Redo Log?' AS pregunta_5;

-- RESPONDER EN INFORME:
-- 1. ___________________________________________________________
-- 2. ___________________________________________________________
-- 3. ___________________________________________________________
-- 4. ___________________________________________________________
-- 5. ___________________________________________________________

-- =====================================================
-- PARTE 9: LIMPIEZA (OPCIONAL)
-- =====================================================
-- EJECUTAR: Solo si desea reiniciar el laboratorio
-- ADVERTENCIA: Esto eliminará todos los datos del lab
-- =====================================================

-- DESCOMENTAR para ejecutar limpieza:
/*
DELETE FROM Pagos_QR WHERE payment_id LIKE 'PAY_LAB3%';
DELETE FROM Auditoria_Transacciones WHERE payment_id LIKE 'PAY_LAB3%';

-- Restaurar saldos originales
UPDATE Cuentas SET saldo = 25.00 WHERE id = 101;  -- Edgar
UPDATE Cuentas SET saldo = 32.50 WHERE id = 103;  -- Anyela
UPDATE Cuentas SET saldo = 45.00 WHERE id = 104;  -- Carlo
UPDATE Cuentas SET saldo = 12.25 WHERE id = 105;  -- Joseph
UPDATE Cuentas SET saldo = 320.75 WHERE id = 202; -- Cafetería UIDE
UPDATE Cuentas SET saldo = 220.00 WHERE id = 209; -- Central Park

SELECT 'Limpieza completada - Laboratorio reiniciado' AS resultado;
*/

-- =====================================================
-- COMANDOS ADICIONALES PARA MONITOREO AVANZADO
-- =====================================================
-- EJECUTAR MANUALMENTE cuando sea necesario
-- =====================================================

SELECT '===== COMANDOS ADICIONALES PARA MONITOREO =====' AS seccion;

-- Ver estado completo de InnoDB
-- EJECUTAR EN CONSOLA: mysql -u root -p
-- SHOW ENGINE INNODB STATUS\G

-- Ver todas las variables de InnoDB
-- EJECUTAR EN WORKBENCH:
-- SHOW VARIABLES LIKE 'innodb%';

-- Ver estadísticas de Buffer Pool
-- EJECUTAR EN CONSOLA:
-- SELECT * FROM information_schema.INNODB_BUFFER_POOL_STATS\G

-- Ver métricas del sistema
-- EJECUTAR EN WORKBENCH:
-- SELECT * FROM sys.metrics WHERE Variable_name LIKE '%innodb%log%';

-- Información sobre tablespaces y archivos
-- EJECUTAR EN WORKBENCH:
-- SELECT * FROM information_schema.INNODB_TABLESPACES;

-- =====================================================
-- RESUMEN DE COMANDOS CRÍTICOS PARA EL INFORME
-- =====================================================

SELECT '===== RESUMEN: COMANDOS EJECUTADOS =====' AS seccion;

SELECT
    'COMANDOS PRINCIPALES EJECUTADOS' AS categoria,
    'SHOW ENGINE INNODB STATUS' AS comando_1,
    'SHOW VARIABLES LIKE innodb_log%' AS comando_2,
    'SHOW STATUS LIKE Innodb_buffer_pool_pages%' AS comando_3,
    'START TRANSACTION ... COMMIT' AS comando_4,
    'ROLLBACK' AS comando_5;

-- =====================================================
-- VALORES A INCLUIR EN EL INFORME TA-1.3
-- =====================================================

SELECT '===== DATOS PARA INFORME TA-1.3 =====' AS seccion;

SELECT
    'MÉTRICAS A REPORTAR' AS categoria,
    '1. Log Sequence Number (inicial vs final)' AS metrica_1,
    '2. Checkpoint Age (inicial vs final)' AS metrica_2,
    '3. Dirty Pages (inicial vs final)' AS metrica_3,
    '4. Bytes escritos al log (Innodb_os_log_written)' AS metrica_4,
    '5. Número de transacciones ejecutadas' AS metrica_5,
    '6. Número de checkpoints observados' AS metrica_6;

-- =====================================================

SELECT 'LABORATORIO COMPLETADO' AS estado,
       'Revisa tus anotaciones para el informe técnico TA-1.3' AS siguiente_paso,
       'Recuerda incluir capturas de SHOW ENGINE INNODB STATUS' AS recordatorio;

-- =====================================================
-- FIN DEL LABORATORIO
-- =====================================================
