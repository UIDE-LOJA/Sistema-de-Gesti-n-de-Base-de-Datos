# Actualización de Compatibilidad MySQL 8.0+

**Fecha:** 13 de noviembre de 2025
**Versión objetivo:** MySQL 8.0.30+ y MySQL 8.4.x (LTS)

## Resumen de Cambios

Todos los archivos de la Semana 3 han sido actualizados para asegurar compatibilidad con las versiones actuales de MySQL (8.0 y 8.4), especialmente considerando los cambios introducidos en MySQL 8.0.30 relacionados con la configuración del Redo Log.

---

## 1. Cambios Críticos en MySQL 8.0.30+

### Parámetros DEPRECADOS (ya no usar):
```ini
# ❌ MySQL 8.0.29 y anteriores
innodb_log_file_size = 512M
innodb_log_files_in_group = 2
```

**Archivos generados (antiguo):**
- `ib_logfile0`
- `ib_logfile1`

### Parámetros ACTUALES (usar desde MySQL 8.0.30):
```ini
# ✅ MySQL 8.0.30+
innodb_redo_log_capacity = 512M
```

**Archivos generados (nuevo):**
- `#innodb_redo/#ib_redo1`
- `#innodb_redo/#ib_redo2`
- `#innodb_redo/#ib_redo3` (dinámico)

**Ventajas del nuevo sistema:**
- Configuración simplificada (un solo parámetro)
- Gestión automática de archivos
- Redimensionamiento dinámico sin reiniciar servidor
- Mejor rendimiento en escritura

---

## 2. Archivos Actualizados

### 2.1 `presentacion.html`

#### Cambios realizados:

**Slide 6 - InnoDB Redo Log:**
- ✅ Actualizado de `innodb_log_file_size` a `innodb_redo_log_capacity`
- ✅ Actualizado de `ib_logfile0/1` a `#ib_redoXXX`
- ✅ Eliminado `innodb_log_files_in_group` (deprecado)
- ✅ Actualizado comando: `SHOW VARIABLES LIKE 'innodb_redo_log%'`
- ✅ Añadido comentario sobre parámetro deprecado

**Slide 6.0.5 - NUEVO:**
- ✅ Slide completamente nueva explicando la transición
- ✅ Comparación visual entre versiones antiguas y nuevas
- ✅ Instrucción para verificar versión: `SELECT VERSION();`
- ✅ Guía de compatibilidad

**Slide 18 - Tabla de Variables:**
- ✅ Actualizado `innodb_log_file_size` a `innodb_redo_log_capacity`
- ✅ Actualizado valores recomendados: 512MB - 2GB

**Slide 19 - Checklist de Configuración:**
- ✅ Actualizado referencia a `innodb_redo_log_capacity`
- ✅ Añadida nota de versión: "(MySQL 8.0.30+)"

### 2.2 `laboratorio_logging_recovery.sql`

#### Cambios realizados:

**Líneas 41-69:**
```sql
-- ✅ ANTES (solo MySQL antiguo):
SHOW VARIABLES LIKE 'innodb_log%';

-- ✅ AHORA (compatible con ambas versiones):
-- Para MySQL 8.0.30+
SHOW VARIABLES LIKE 'innodb_redo_log%';
-- Para MySQL 8.0.29 y anteriores
SHOW VARIABLES LIKE 'innodb_log%';
```

**Variables mostradas:**
- ✅ Eliminado `innodb_log_file_size` (deprecado)
- ✅ Eliminado `innodb_log_files_in_group` (deprecado)
- ✅ Mantenido `innodb_log_buffer_size` (vigente)
- ✅ Añadido `VERSION()` para verificar compatibilidad

**Comentarios actualizados:**
```sql
-- ANOTAR: Los siguientes valores importantes:
--   MySQL 8.0.30+:
--     - innodb_redo_log_capacity: Capacidad total del Redo Log
--   MySQL 8.0.29 y anteriores:
--     - innodb_log_file_size: Tamaño de cada archivo de Redo Log (DEPRECADO)
--     - innodb_log_files_in_group: Número de archivos (DEPRECADO)
--   Todas las versiones:
--     - innodb_log_buffer_size: Buffer en memoria para Redo Log
```

### 2.3 `PE-1.3-instrucciones.html`

#### Cambios realizados:

**Sección de Recursos:**
- ✅ Añadida nota de compatibilidad visual
- ✅ Lista de comandos verificados:
  - `SHOW VARIABLES LIKE 'log_bin'` ✓
  - `SHOW BINARY LOGS` ✓
  - `SHOW BINLOG EVENTS` ✓
  - `START TRANSACTION` ✓
  - `COMMIT` ✓
  - `UPDATE` ✓
  - `INSERT` ✓
- ✅ Confirmación: "Verificado con documentación oficial MySQL 2025"

---

## 3. Comandos NO Afectados (Siguen Vigentes)

Los siguientes comandos y parámetros **NO han cambiado** y funcionan en todas las versiones:

### Comandos SQL:
```sql
✓ START TRANSACTION;
✓ COMMIT;
✓ ROLLBACK;
✓ UPDATE tabla SET ...;
✓ INSERT INTO tabla VALUES ...;
✓ SELECT ... FROM ...;
```

### Binary Log:
```sql
✓ SHOW VARIABLES LIKE 'log_bin';
✓ SHOW BINARY LOGS;
✓ SHOW BINLOG EVENTS;
✓ SHOW MASTER STATUS;
```

### Parámetros InnoDB:
```ini
✓ innodb_flush_log_at_trx_commit = 1
✓ innodb_log_buffer_size = 16M
✓ innodb_buffer_pool_size = 1G
✓ innodb_file_per_table = ON
```

---

## 4. Verificación de Versión

### Antes de configurar, verifica tu versión:

```sql
SELECT VERSION();
```

**Ejemplos de salida:**
```
8.0.43-0ubuntu0.22.04.1  → Usar innodb_redo_log_capacity
8.0.29                   → Usar innodb_log_file_size
8.4.6                    → Usar innodb_redo_log_capacity (LTS)
5.7.44                   → Usar innodb_log_file_size
```

### Regla simple:
- **MySQL ≥ 8.0.30:** Usa `innodb_redo_log_capacity`
- **MySQL < 8.0.30:** Usa `innodb_log_file_size`

---

## 5. Configuración Recomendada

### Para MySQL 8.0.30+ y 8.4.x (ACTUAL):

**Archivo:** `my.cnf` (Linux/Mac) o `my.ini` (Windows)

```ini
[mysqld]
# === Redo Log (MySQL 8.0.30+) ===
innodb_redo_log_capacity = 512M

# === Binary Log ===
log_bin = mysql-bin
binlog_format = ROW
expire_logs_days = 7

# === Durabilidad ===
innodb_flush_log_at_trx_commit = 1
sync_binlog = 1

# === Buffer Pool ===
innodb_buffer_pool_size = 1G
innodb_log_buffer_size = 16M
```

### Para MySQL 8.0.29 y anteriores (LEGACY):

```ini
[mysqld]
# === Redo Log (MySQL ≤ 8.0.29) - DEPRECADO ===
innodb_log_file_size = 512M
innodb_log_files_in_group = 2

# === Binary Log ===
log_bin = mysql-bin
binlog_format = ROW
expire_logs_days = 7

# === Durabilidad ===
innodb_flush_log_at_trx_commit = 1
sync_binlog = 1

# === Buffer Pool ===
innodb_buffer_pool_size = 1G
innodb_log_buffer_size = 16M
```

---

## 6. Impacto en las Prácticas

### PE-1.3 (Laboratorio WAL y Binary Log):
- ✅ **SIN CAMBIOS** en comandos SQL
- ✅ Todos los comandos son compatibles con MySQL 8.0 y 8.4
- ✅ Añadida nota de compatibilidad en instrucciones

### TA-1.3 (Resumen ARIES):
- ✅ Conceptos teóricos siguen vigentes
- ✅ Referencias a InnoDB actualizadas en presentación

### Laboratorio General:
- ✅ Actualizado para mostrar variables correctas según versión
- ✅ Añadida verificación de versión MySQL

---

## 7. Referencias Oficiales

### Documentación MySQL 8.0:
- **Redo Log Changes:** https://dev.mysql.com/doc/refman/8.0/en/innodb-redo-log.html
- **Binary Log:** https://dev.mysql.com/doc/refman/8.0/en/binary-log.html
- **Release Notes 8.0.30:** https://dev.mysql.com/doc/relnotes/mysql/8.0/en/news-8-0-30.html

### Documentación MySQL 8.4 (LTS):
- **What's New:** https://dev.mysql.com/doc/refman/8.4/en/mysql-nutshell.html
- **InnoDB Configuration:** https://dev.mysql.com/doc/refman/8.4/en/innodb-configuration.html

---

## 8. Cronología de Versiones MySQL

```
MySQL 5.7 (Oct 2015 - Oct 2023)
  └─ innodb_log_file_size ✓

MySQL 8.0.0 (Apr 2018)
  └─ innodb_log_file_size ✓

MySQL 8.0.30 (Jul 2022) ← CAMBIO IMPORTANTE
  └─ innodb_log_file_size DEPRECADO
  └─ innodb_redo_log_capacity NUEVO ✓

MySQL 8.0.43 (Jul 2025) [Actual]
  └─ innodb_redo_log_capacity ✓

MySQL 8.4.0 (Apr 2024) [LTS]
  └─ innodb_redo_log_capacity ✓

MySQL 8.4.6 (Jul 2025) [LTS Actual]
  └─ innodb_redo_log_capacity ✓
```

**Nota:** MySQL 6.x nunca existió como versión GA (General Availability). La línea 6.0 fue discontinuada en fase alpha en 2009.

---

## 9. Preguntas Frecuentes

### ¿Por qué MySQL cambió innodb_log_file_size?
Para simplificar la administración y permitir redimensionamiento dinámico sin reiniciar el servidor.

### ¿Puedo seguir usando innodb_log_file_size?
Sí, en MySQL 8.0.29 y anteriores. En MySQL 8.0.30+ está deprecado pero aún funciona con advertencias. En versiones futuras será removido.

### ¿Afecta esto al Binary Log?
No. El Binary Log usa parámetros completamente diferentes (`log_bin`, `binlog_format`, etc.) que no han cambiado.

### ¿Necesito migrar mi configuración?
Si usas MySQL 8.0.30 o superior, es recomendado actualizar a `innodb_redo_log_capacity` para evitar advertencias y prepararte para futuras versiones.

### ¿Funcionan los scripts SQL antiguos?
Sí. Los comandos SQL (`START TRANSACTION`, `COMMIT`, `UPDATE`, etc.) no cambiaron. Solo los parámetros de configuración del servidor.

---

## 10. Checklist de Actualización

Para docentes/administradores:

- [x] Actualizada presentación con nueva configuración Redo Log
- [x] Añadida slide explicando cambios en MySQL 8.0.30+
- [x] Actualizado laboratorio SQL con comandos compatibles
- [x] Añadida verificación de versión en scripts
- [x] Actualizada PE-1.3 con nota de compatibilidad
- [x] Documentados comandos que NO cambiaron
- [x] Creado documento de actualización (este archivo)
- [x] Verificadas referencias a documentación oficial MySQL 2025

Para estudiantes:

- [ ] Verificar versión de MySQL instalada: `SELECT VERSION();`
- [ ] Usar configuración correcta según versión
- [ ] Revisar Slide 6.0.5 de la presentación (cambios importantes)
- [ ] Ejecutar comandos SQL según guías actualizadas
- [ ] Consultar este documento en caso de dudas sobre versiones

---

## 11. Contacto y Soporte

Si encuentras problemas relacionados con versiones de MySQL:

1. **Verificar versión primero:** `SELECT VERSION();`
2. **Consultar Slide 6.0.5** de la presentación
3. **Revisar este documento** para configuración correcta
4. **Contactar al docente** en horarios de tutoría

---

**Documento creado:** 13 de noviembre de 2025
**Autor:** Prof. Charlie Cárdenas Toledo, M.Sc.
**Curso:** LTI_05A_300-SGBD-ASC
**Última actualización:** 13/11/2025
