# PE-1.3 Guía Rápida
## Laboratorio: Binary Log en MySQL
**Sistema de Pagos QR "¡ahorita!" - Banco de Loja**

---

## ⏱️ Duración: 60 minutos

**Estudiante:** `_______________________`
**Cuenta asignada:** ID `___` (entre 101-127)
**Fecha:** `___________`

---

## 📝 Pasos a seguir

### PASO 1: Verificar Binary Log (5 min)

```sql
SHOW VARIABLES LIKE 'log_bin';
```

**📸 CAPTURA 1:** Resultado debe mostrar `ON`

---

### PASO 2: Ejecutar Transacciones (30 min)

#### 2.1 Ver tu saldo inicial

```sql
USE pagos_qr_sistema;

SELECT id, titular, saldo, limite_diario
FROM Cuentas
WHERE id = XXX;  -- Reemplaza XXX con tu ID
```

**📸 CAPTURA 2:** Tu saldo inicial

**Saldo inicial:** $`_______`

---

#### 2.2 Realizar 3 pagos QR

**IMPORTANTE:** Reemplaza `XXX` con tu ID en todos los comandos

**Transacción 1: Cafetería UIDE ($2.50)**
```sql
START TRANSACTION;
UPDATE Cuentas SET saldo = saldo - 2.50 WHERE id = XXX;
UPDATE Cuentas SET saldo = saldo + 2.50 WHERE id = 202;
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, descripcion, estado, metodo_pago)
VALUES (CONCAT('PAY_PE13_', XXX, '_001'), XXX, 2, 2.50, 'PE 1.3 - Desayuno', 'CONFIRMADO', 'QR_AHORITA');
COMMIT;
```

**Transacción 2: Transporte ($0.35)**
```sql
START TRANSACTION;
UPDATE Cuentas SET saldo = saldo - 0.35 WHERE id = XXX;
UPDATE Cuentas SET saldo = saldo + 0.35 WHERE id = 208;
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, descripcion, estado, metodo_pago)
VALUES (CONCAT('PAY_PE13_', XXX, '_002'), XXX, 8, 0.35, 'PE 1.3 - Pasaje', 'CONFIRMADO', 'QR_AHORITA');
COMMIT;
```

**Transacción 3: Minimarket ($1.50)**
```sql
START TRANSACTION;
UPDATE Cuentas SET saldo = saldo - 1.50 WHERE id = XXX;
UPDATE Cuentas SET saldo = saldo + 1.50 WHERE id = 206;
INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, descripcion, estado, metodo_pago)
VALUES (CONCAT('PAY_PE13_', XXX, '_003'), XXX, 6, 1.50, 'PE 1.3 - Snacks', 'CONFIRMADO', 'QR_AHORITA');
COMMIT;
```

**📸 CAPTURA 3:** Confirmación de las transacciones

---

#### 2.3 Verificar saldo final

```sql
SELECT id, titular, saldo FROM Cuentas WHERE id = XXX;
```

**📸 CAPTURA 4:** Tu saldo final

**Saldo final:** $`_______`
**Cambio:** -$4.35 ✅

---

#### 2.4 Ver tus transacciones

```sql
SELECT payment_id, monto, descripcion, estado, fecha
FROM Pagos_QR
WHERE payment_id LIKE CONCAT('PAY_PE13_', XXX, '%')
ORDER BY fecha;
```

**📸 CAPTURA 5:** Tus 3 transacciones

---

### PASO 3: Ver Binary Logs (15 min)

#### 3.1 Lista de archivos

```sql
SHOW BINARY LOGS;
```

**📸 CAPTURA 6:** Lista de binary logs

**Archivo actual:** `___________________`
**Tamaño:** `_______` bytes

---

#### 3.2 Ver eventos

```sql
SHOW BINLOG EVENTS LIMIT 10;
```

**📸 CAPTURA 7:** Eventos del binary log

---

### PASO 4: Explicación (10 min)

**Pregunta:** ¿Para qué sirve el binary log en el Sistema de Pagos QR?

Escribe 2-3 líneas:

```
1. _____________________________________________________________
   _____________________________________________________________

2. _____________________________________________________________
   _____________________________________________________________

3. _____________________________________________________________
   _____________________________________________________________
```

**Pistas:**
- Recuperación ante fallos
- Replicación de datos
- Auditoría de transacciones

---

## ✅ Checklist de Entrega

- [ ] **Captura 1:** Verificación de `log_bin = ON`
- [ ] **Captura 2:** Saldo inicial de tu cuenta
- [ ] **Captura 3:** Confirmación de transacciones
- [ ] **Captura 4:** Saldo final de tu cuenta
- [ ] **Captura 5:** Tus 3 transacciones registradas
- [ ] **Captura 6:** Lista de binary logs
- [ ] **Captura 7:** Eventos del binary log
- [ ] **Explicación:** 2-3 líneas sobre el binary log
- [ ] **PDF:** Nomenclatura `PE-1.3_ApellidoNombre_WAL.pdf`

---

## 📊 Resumen de cálculos

| Concepto | Monto |
|----------|-------|
| Saldo inicial | $`_____` |
| Desayuno Cafetería | -$2.50 |
| Pasaje Transporte | -$0.35 |
| Snacks Minimarket | -$1.50 |
| **Total gastado** | **-$4.35** |
| **Saldo final** | $`_____` |

---

## 🎯 Información de Comercios

| ID  | Nombre | Categoría |
|-----|--------|-----------|
| 202 | Cafetería UIDE Campus Loja | CAFETERIA |
| 206 | Minimarket Don Pepe | MINIMARKET |
| 208 | Transporte Urbano Loja | TRANSPORTE |

---

**Valor:** 2.25 puntos
**Tiempo:** 60 minutos
**Modalidad:** Presencial

---

*Guía simplificada para PE-1.3*
*Sistemas de Gestión de Base de Datos - UIDE Loja*
