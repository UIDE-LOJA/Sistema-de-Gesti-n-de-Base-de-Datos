-- PE-1.2 – Concurrencia: dirty / non-repeatable / phantom (2 sesiones)
-- Este script incluye bloques para MySQL (InnoDB) y PostgreSQL.
-- Usa DOS sesiones SQL (A y B). Copia/pega los bloques según tu SGBD.
-- Nota: Dirty reads no están permitidos en PostgreSQL (Read Uncommitted ≈ Read Committed).

-- =========================
-- 0) PREPARACIÓN (común)
-- =========================
-- Crear tablas de prueba (ejecuta una sola vez)
DROP TABLE IF EXISTS items;
CREATE TABLE items (
  id   INT PRIMARY KEY,
  stock INT
);

INSERT INTO items (id, stock) VALUES (1, 100);

DROP TABLE IF EXISTS movimientos;
CREATE TABLE movimientos (
  id   SERIAL PRIMARY KEY,
  monto INT
);

INSERT INTO movimientos (monto) VALUES (50), (120), (200);

-- =====================================
-- 1) DIRTY READ (lectura sucia)
-- =====================================
-- MySQL (InnoDB) / Session A
-- Objetivo: ver si B puede leer el valor NO confirmado de A en READ UNCOMMITTED (solo si el motor lo permite).
-- ADVERTENCIA: En PostgreSQL no es reproducible (el motor no permite dirty read).
-- -------------------------------------------------------------------
-- Session A:
--   SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
--   START TRANSACTION;
--   UPDATE items SET stock = stock - 10 WHERE id = 1;
--   -- NO HAGAS COMMIT TODAVÍA

-- Session B (MySQL):
--   SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
--   SELECT stock FROM items WHERE id = 1;
--   -- ¿Ves 90? (si el motor expone cambios no confirmados) 
--   -- Cambia a READ COMMITTED y vuelve a probar:
--   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
--   SELECT stock FROM items WHERE id = 1;

-- Session A:
--   ROLLBACK;  -- Deshaz el cambio

-- PostgreSQL (INFO):
--   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  -- Internamente ≈ READ COMMITTED
--   -- No observarás lectura sucia; verás 100 siempre hasta el COMMIT.

-- =====================================
-- 2) NON-REPEATABLE READ (lectura no repetible)
-- =====================================
-- Escenario: A lee, B modifica y confirma, A vuelve a leer y observa valor distinto.
-- Usa READ COMMITTED (MySQL o PostgreSQL).

-- Session A:
--   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
--   START TRANSACTION;
--   SELECT stock FROM items WHERE id = 1;   -- Lectura inicial

-- Session B:
--   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
--   START TRANSACTION;
--   UPDATE items SET stock = stock - 5 WHERE id = 1;
--   COMMIT;

-- Session A:
--   SELECT stock FROM items WHERE id = 1;   -- ¿Valor cambió? (lectura no repetible)
--   COMMIT;

-- =====================================
-- 3) PHANTOM READ (lectura fantasma)
-- =====================================
-- Escenario: A cuenta filas con condición; B inserta una fila que cumple la condición; A vuelve a contar.
-- Para observar fantasmas, usa READ COMMITTED en A.

-- Session A:
--   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
--   START TRANSACTION;
--   SELECT COUNT(*) FROM movimientos WHERE monto > 100;  -- Conteo inicial

-- Session B:
--   START TRANSACTION;
--   INSERT INTO movimientos (monto) VALUES (150);
--   COMMIT;

-- Session A:
--   SELECT COUNT(*) FROM movimientos WHERE monto > 100;  -- ¿Aumentó el conteo? (fantasma)
--   COMMIT;

-- OPCIONAL: Repite PHANTOM con REPEATABLE READ
--   En PostgreSQL, REPEATABLE READ (snapshot) evita ver la nueva fila dentro de la misma transacción A.
--   En MySQL (InnoDB), REPEATABLE READ con next-key locks puede evitar fantasmas según el plan/índices.

-- FIN
