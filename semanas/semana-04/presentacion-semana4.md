# Presentación Semana 4: Optimización de Consultas con Estadísticas, Índices y Planes
## Caso de Uso Conductor: Sistema de Pagos QR “¡ahorita!”

---

## 🎯 Objetivos de la Presentación

- Fortalecer el motor de “¡ahorita!” garantizando **estadísticas frescas y filtros selectivos**.
- Diseñar una **estrategia de índices** que equilibre validaciones antifraude con escrituras de pagos en tiempo real.
- Dominar **EXPLAIN / EXPLAIN ANALYZE** para detectar cuellos de botella durante horas pico de escaneo QR.
- Traducir hallazgos técnicos en tareas de mantenimiento preventivo para el core transaccional.

---

## 📊 Agenda

1. **Contexto del Caso ¡ahorita!**
2. **Estadísticas, selectividad y ANALYZE**
3. **Índices: tipos, costos y trade-offs**
4. **Planes de ejecución y lectura práctica**
5. **Implicaciones para la plataforma QR**

---

## 📲 Caso de Uso: Pagos QR en Tiempo Real

> *“¡ahorita!” liquida miles de transacciones por minuto; un plan deficiente se traduce en pagos rechazados o confirmaciones tardías.*

- **Modelo de datos (Semana 2)**: base `pagos_qr_sistema` con `Cuentas`, `Comercios`, `Pagos_QR`, `Auditoria_Transacciones`, `Limites_Diarios` y vistas (`v_transacciones_hoy`, `v_estadisticas_comercios`).
- **Datos de laboratorio (Semana 3)**: transacciones PE‑1.3 (`PAY_PE13_<ID>_00X`) que debitan la cuenta 101‑127 y acreditan comercios como Cafetería (202) o Transporte (208).
- **Dolor actual**: conciliaciones y alertas antifraude tardan >5 s durante “Cashback Cafeterías”, generando timeouts en el app móvil.
- **Meta**: respuestas <2 s manteniendo estadísticas, índices y planes alineados a esta misma base de datos.

---

## 📈 Estadísticas y Selectividad en Acción

- El **optimizador** necesita estadísticas frescas sobre `Pagos_QR.fecha`, `estado`, `monto`, `Comercios.ciudad` y `Cuentas.estado`.
- Desalineaciones entre `rows` estimadas y reales obligan a leer toda la tabla: ej. `Seq Scan Pagos_QR` cuando bastaría el índice `idx_comercio_fecha`.
- Plan para “¡ahorita!”:
  - Automatizar `ANALYZE Pagos_QR`, `ANALYZE Cuentas`, `ANALYZE Comercios` cada madrugada y tras los scripts masivos (`02_insertar_datos_practica.sql`, PE‑1.3).
  - Monitorizar `Rows Removed by Filter` (selectividad real) en consultas como `estado = 'PROCESANDO'` o `metodo_pago = 'QR_SCAN'`.
  - Refrescar estadísticas cuando la diferencia estimado/real >20 % en reportes (conciliación diaria, límites diarios).

---

## 🗂️ Índices y su Impacto en el Costo

- Los índices definidos en los scripts (`idx_cliente_fecha`, `idx_comercio_fecha`, `idx_estado`) evitan **Seq Scan** cuando se filtra por comercio, cliente o estado.
- Ajustes recomendados:
  - **Clave primaria existente** `Pagos_QR(payment_id)` → mantiene trazabilidad de `PAY_YYYYMMDD_ID`.
  - **Compuesto** `Pagos_QR(comercio_id, fecha)` (ya en el DDL) → soporta dashboards por comercio y ventana temporal.
  - **Cubierto nuevo** `Pagos_QR(cliente_id, estado, metodo_pago) INCLUDE (monto, dispositivo)` → consultas antifraude que hoy golpean tabla completa.
- **Trade-off**: cada índice se actualiza en operaciones de las prácticas (Transacción 1‑3, scripts de carga). Exceso degrada el throughput de `INSERT INTO Pagos_QR`.
- Guía práctica:
  - Revisar `idx_*` ya definidos antes de crear nuevos; consolidar índices redundantes (`idx_estado` vs. `idx_cliente_estado` hipotético).
  - Usar estadísticas de uso (`pg_stat_user_indexes` o `information_schema.STATISTICS`) para justificar cada índice.

---

## 💸 Costos de Ejecución y E/S

- El plan `cost = inicio..total` combina CPU + I/O; leer el archivo de datos de `Pagos_QR` sigue siendo lo más caro.
- Índices tipo B+ tree (los mismos creados en `01_crear_base_datos.sql`) reducen E/S porque operan sobre páginas pequeñas y evitan escaneos secuenciales.
- Cada índice adicional se refleja en los logs binarios de la práctica (Semana 3): mayor escritura lors de `INSERT`, `UPDATE`, `DELETE`.
- Estrategia “¡ahorita!”:
  - Mantener el core OLTP con los índices definidos en el DDL base y mover reportes a réplicas (`mysqldump + replica`).
  - Validar el impacto en I/O (Performance Schema / `SHOW ENGINE INNODB STATUS`) antes de agregar índices para campañas temporales.

---

## 🔍 Planes de Ejecución (EXPLAIN / EXPLAIN ANALYZE)

- **EXPLAIN** = plan estimado; **EXPLAIN ANALYZE** = plan + métricas reales (solo en entornos controlados).
- Lectura:
  - Nodos (`Seq Scan`, `Index Scan`, `Nested Loop`, `Hash Join`).
  - `Rows` estimadas vs. reales para confirmar que las estadísticas reflejan las tablas creadas en Semana 2.
  - `Planning Time` / `Execution Time` y campo `Extra` (`Using index condition; Using where`).
- Ejemplo sobre la misma base:
```sql
EXPLAIN SELECT payment_id, monto, estado
FROM Pagos_QR
WHERE comercio_id = 202
  AND fecha >= NOW() - INTERVAL 5 MINUTE
ORDER BY fecha DESC;
```
- Objetivo: verificar uso de `idx_comercio_fecha`, que `Rows` estimadas ~ reales (gracias a ANALYZE) y evitar `Using temporary` o `filesort`.

---

## 🧭 Implicaciones para “¡ahorita!”

1. **Gobernar estadísticas**: automatizar `ANALYZE` sobre las tablas de Semana 2 y habilitar alertas cuando estimado vs. real divergen en planes.
2. **Índices con propósito**: documentar cada índice existente en el DDL y justificar los nuevos a partir de los patrones detectados en PE‑1.3.
3. **Planes como ritual**: ningún SQL que toque `Pagos_QR`, `Cuentas` o `Auditoria_Transacciones` se promueve sin `EXPLAIN` (y `EXPLAIN ANALYZE` en staging).
4. **Balancear lecturas/escrituras**: evaluar el costo antes de agregar índices para dashboards; usar réplicas si el consumo proviene de analítica.
5. **Checklist de resiliencia**: previo a eventos de alto tráfico, correr scripts de verificación (stats frescas, lag de réplica, planes) sobre la misma base de datos de las semanas previas.

---

## 📚 Referencias Clave

- DBA24. *Explain Plan en PostgreSQL: Análisis, Optimización y Herramientas.*
- OneNine. *Cómo analizar y reducir el tiempo de ejecución de consultas.*
- Google Cloud. *Cómo obtener y analizar los planes de explicación de AlloyDB.*
- FdI. *Diseño de bases de datos relacionales – Índices y costos.*
- Orbegozo Arana, B. *Curso práctico avanzado de PostgreSQL.*

---

*Presentación elaborada a partir del Compendio Semana 4 – Estadísticas, Índices y Planes de Ejecución.*
