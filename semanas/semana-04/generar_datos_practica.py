#!/usr/bin/env python3
"""
================================================================================
GENERADOR DE DATOS MASIVOS PARA PRÁCTICA DE OPTIMIZACIÓN
Semana 4: Optimización de Consultas - Sistema pagos_qr_sistema
================================================================================
Genera ~10,000 transacciones realistas con contexto ecuatoriano para:
- Análisis de planes de ejecución con EXPLAIN
- Comparación de rendimiento con/sin índices
- Práctica PE-1.4: Optimización de Consultas
================================================================================
"""

import random
from datetime import datetime, timedelta
from typing import List, Tuple

# Configuración
NUM_TRANSACCIONES = 10000
FECHA_INICIO = datetime(2024, 9, 1)  # Septiembre 2024
FECHA_FIN = datetime(2025, 2, 28)     # Febrero 2025

# Comercios adicionales con contexto ecuatoriano
COMERCIOS_ECUADOR = [
    # Quito
    (211, 'Supermercados Santa María Quito', 'QR_SANTA_MARIA_QTO_2024_011', 'Quito', 'MINIMARKET', 850.00, 5000.00),
    (212, 'Farmacia Fybeca Quito Norte', 'QR_FYBECA_QTO_2024_012', 'Quito', 'FARMACIA', 420.50, 3000.00),
    (213, 'Gasolinera Petroecuador La Mariscal', 'QR_PETRO_MARISCAL_2024_013', 'Quito', 'GASOLINERA', 1100.00, 6000.00),
    (214, 'Restaurante La Choza Quito', 'QR_LA_CHOZA_QTO_2024_014', 'Quito', 'RESTAURANTE', 390.25, 2000.00),
    (215, 'Cafetería Juan Valdez Quito', 'QR_JUAN_VALDEZ_QTO_2024_015', 'Quito', 'CAFETERIA', 310.00, 2000.00),
    # Guayaquil
    (216, 'Minimarket Mi Comisariato Guayaquil', 'QR_COMISARIATO_GYE_2024_016', 'Guayaquil', 'MINIMARKET', 920.75, 5000.00),
    (217, 'Farmacia Cruz Azul Guayaquil', 'QR_CRUZ_AZUL_GYE_2024_017', 'Guayaquil', 'FARMACIA', 380.50, 3000.00),
    (218, 'Transporte Metrovía Guayaquil', 'QR_METROVIA_GYE_2024_018', 'Guayaquil', 'TRANSPORTE', 650.00, 4000.00),
    (219, 'Panadería Sweet & Coffee Guayaquil', 'QR_SWEET_COFFEE_GYE_2024_019', 'Guayaquil', 'PANADERIA', 290.25, 1500.00),
    (220, 'Restaurante La Canoa Guayaquil', 'QR_LA_CANOA_GYE_2024_020', 'Guayaquil', 'RESTAURANTE', 410.00, 2500.00),
    # Cuenca
    (221, 'Supermaxi Cuenca', 'QR_SUPERMAXI_CUE_2024_021', 'Cuenca', 'MINIMARKET', 780.00, 5000.00),
    (222, 'Farmacia Sana Sana Cuenca', 'QR_SANA_SANA_CUE_2024_022', 'Cuenca', 'FARMACIA', 350.75, 3000.00),
    (223, 'Gasolinera Mobil Cuenca', 'QR_MOBIL_CUE_2024_023', 'Cuenca', 'GASOLINERA', 890.00, 5000.00),
    (224, 'Cafetería Tiestos Cuenca', 'QR_TIESTOS_CUE_2024_024', 'Cuenca', 'CAFETERIA', 260.50, 1500.00),
    (225, 'Minimarket TIA Cuenca', 'QR_TIA_CUE_2024_025', 'Cuenca', 'MINIMARKET', 540.25, 3000.00),
    # Otras ciudades
    (226, 'Farmacia Medicity Ambato', 'QR_MEDICITY_AMB_2024_026', 'Ambato', 'FARMACIA', 310.00, 2500.00),
    (227, 'Supermercados AKÍ Manta', 'QR_AKI_MANTA_2024_027', 'Manta', 'MINIMARKET', 690.50, 4000.00),
    (228, 'Transporte Cooperativa Riobamba', 'QR_COOP_RIO_2024_028', 'Riobamba', 'TRANSPORTE', 420.00, 3000.00),
    (229, 'Gasolinera Primax Ibarra', 'QR_PRIMAX_IBA_2024_029', 'Ibarra', 'GASOLINERA', 580.75, 4000.00),
    (230, 'Cafetería Dulce Placer Machala', 'QR_DULCE_PLACER_MCH_2024_030', 'Machala', 'CAFETERIA', 240.00, 1500.00),
]

# Descripciones realistas por categoría
DESCRIPCIONES = {
    'CAFETERIA': ['Desayuno', 'Café y croissant', 'Almuerzo ejecutivo', 'Snack vespertino', 'Café americano', 'Capuccino y pastel'],
    'RESTAURANTE': ['Cena familiar', 'Almuerzo', 'Menú del día', 'Cena romántica', 'Comida rápida', 'Plato típico'],
    'FARMACIA': ['Medicamentos', 'Vitaminas', 'Analgésicos', 'Productos dermocosméticos', 'Antigripales', 'Suplementos'],
    'TRANSPORTE': ['Pasaje urbano', 'Transporte interprovincial', 'Recarga tarjeta transporte', 'Boleto bus', 'Pasaje Metrovía'],
    'GASOLINERA': ['Carga gasolina Extra', 'Carga Diesel', 'Gasolina Super', 'Combustible full tank', 'Recarga $20'],
    'MINIMARKET': ['Compras semanales', 'Productos básicos', 'Snacks y bebidas', 'Despensa mensual', 'Compras express'],
    'PANADERIA': ['Pan fresco', 'Pan de dulce', 'Pasteles', 'Empanadas', 'Pan integral', 'Torta'],
}

DISPOSITIVOS = ['iPhone 13', 'Samsung S21', 'Xiaomi Redmi Note', 'Motorola G', 'Huawei P30',
                'iPhone 14', 'OnePlus 9', 'Samsung A52', 'iPhone 12 Pro', 'Realme GT']


def generar_fecha_aleatoria() -> datetime:
    """Genera una fecha/hora aleatoria entre FECHA_INICIO y FECHA_FIN en horario realista (6am-10pm)"""
    delta = FECHA_FIN - FECHA_INICIO
    random_days = random.randint(0, delta.days)
    fecha = FECHA_INICIO + timedelta(days=random_days)

    # Hora entre 6 AM y 10 PM
    hora = random.randint(6, 22)
    minuto = random.randint(0, 59)
    segundo = random.randint(0, 59)

    return fecha.replace(hour=hora, minute=minuto, second=segundo)


def generar_monto() -> float:
    """Genera un monto realista: 70% transacciones pequeñas, 30% mayores"""
    if random.random() < 0.7:
        # Transacciones pequeñas: $0.35 - $10.00
        return round(random.uniform(0.35, 10.00), 2)
    else:
        # Transacciones mayores: $10.00 - $50.00
        return round(random.uniform(10.00, 50.00), 2)


def generar_estado() -> str:
    """Genera estado de transacción: 95% CONFIRMADO, 3% FALLIDO, 2% REVERTIDO"""
    rand = random.random()
    if rand < 0.95:
        return 'CONFIRMADO'
    elif rand < 0.98:
        return 'FALLIDO'
    else:
        return 'REVERTIDO'


def generar_descripcion(categoria: str) -> str:
    """Genera descripción realista según categoría del comercio"""
    if categoria in DESCRIPCIONES:
        return random.choice(DESCRIPCIONES[categoria])
    return 'Pago comercio'


def generar_transacciones() -> List[Tuple]:
    """Genera lista de transacciones con todos los datos"""
    transacciones = []
    comercios_ids = list(range(1, 31))  # IDs 1-30 (10 originales + 20 nuevos)
    clientes_ids = list(range(101, 129))  # IDs 101-128 (estudiantes)

    # Mapeo de categorías por comercio (simplificado)
    categorias_comercios = {
        1: 'TRANSPORTE', 2: 'CAFETERIA', 3: 'FARMACIA', 4: 'GASOLINERA', 5: 'FARMACIA',
        6: 'MINIMARKET', 7: 'PANADERIA', 8: 'TRANSPORTE', 9: 'CAFETERIA', 10: 'RESTAURANTE',
        11: 'MINIMARKET', 12: 'FARMACIA', 13: 'GASOLINERA', 14: 'RESTAURANTE', 15: 'CAFETERIA',
        16: 'MINIMARKET', 17: 'FARMACIA', 18: 'TRANSPORTE', 19: 'PANADERIA', 20: 'RESTAURANTE',
        21: 'MINIMARKET', 22: 'FARMACIA', 23: 'GASOLINERA', 24: 'CAFETERIA', 25: 'MINIMARKET',
        26: 'FARMACIA', 27: 'MINIMARKET', 28: 'TRANSPORTE', 29: 'GASOLINERA', 30: 'CAFETERIA',
    }

    for i in range(NUM_TRANSACCIONES):
        cliente_id = random.choice(clientes_ids)
        comercio_id = random.choice(comercios_ids)
        monto = generar_monto()
        fecha = generar_fecha_aleatoria()
        estado = generar_estado()
        categoria = categorias_comercios.get(comercio_id, 'OTROS')
        descripcion = generar_descripcion(categoria)
        dispositivo = random.choice(DISPOSITIVOS)
        ip_origen = f'192.168.{random.randint(1, 255)}.{random.randint(1, 255)}'

        # Payment ID único
        payment_id = f'PAY_{fecha.strftime("%Y%m%d")}_{cliente_id}_{comercio_id}_{i:06d}'

        transacciones.append((
            payment_id, cliente_id, comercio_id, monto, fecha,
            estado, descripcion, 'QR_SCAN', ip_origen, dispositivo
        ))

    return transacciones


def generar_sql_completo() -> str:
    """Genera el script SQL completo"""
    sql_lines = [
        "-- " + "=" * 77,
        "-- SCRIPT DE DATOS MASIVOS PARA PRÁCTICA DE OPTIMIZACIÓN",
        "-- Semana 4: Optimización de Consultas - Sistema pagos_qr_sistema",
        "-- Generado automáticamente con Python",
        f"-- Fecha de generación: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
        f"-- Total de transacciones: {NUM_TRANSACCIONES:,}",
        "-- " + "=" * 77,
        "",
        "USE pagos_qr_sistema;",
        "",
        "-- " + "=" * 77,
        "-- PASO 1: INSERTAR CUENTAS DE COMERCIOS ADICIONALES",
        "-- " + "=" * 77,
        "",
        "INSERT IGNORE INTO Cuentas (id, titular, saldo, limite_diario, estado) VALUES"
    ]

    # Insertar cuentas de comercios
    for i, comercio in enumerate(COMERCIOS_ECUADOR):
        cuenta_id, nombre, _, _, _, saldo, limite = comercio
        comma = "," if i < len(COMERCIOS_ECUADOR) - 1 else ";"
        sql_lines.append(f"({cuenta_id}, '{nombre}', {saldo}, {limite}, 'ACTIVA'){comma}")

    sql_lines.extend([
        "",
        "-- " + "=" * 77,
        "-- PASO 2: INSERTAR COMERCIOS AFILIADOS",
        "-- " + "=" * 77,
        "",
        "INSERT IGNORE INTO Comercios (id, nombre, cuenta_bancoloja, qr_code, ciudad, categoria, estado) VALUES"
    ])

    # Insertar comercios
    for i, comercio in enumerate(COMERCIOS_ECUADOR):
        cuenta_id, nombre, qr_code, ciudad, categoria, _, _ = comercio
        comercio_id = i + 11  # IDs 11-30
        comma = "," if i < len(COMERCIOS_ECUADOR) - 1 else ";"
        sql_lines.append(f"({comercio_id}, '{nombre}', {cuenta_id}, '{qr_code}', '{ciudad}', '{categoria}', 'ACTIVO'){comma}")

    sql_lines.extend([
        "",
        "-- " + "=" * 77,
        "-- PASO 3: INSERTAR TRANSACCIONES MASIVAS",
        f"-- Total: {NUM_TRANSACCIONES:,} transacciones",
        f"-- Período: {FECHA_INICIO.strftime('%Y-%m-%d')} a {FECHA_FIN.strftime('%Y-%m-%d')}",
        "-- " + "=" * 77,
        ""
    ])

    # Generar transacciones
    print(f"Generando {NUM_TRANSACCIONES:,} transacciones...")
    transacciones = generar_transacciones()

    # Insertar en lotes de 500 para mejor rendimiento
    batch_size = 500
    for batch_num in range(0, len(transacciones), batch_size):
        batch = transacciones[batch_num:batch_num + batch_size]
        sql_lines.append(f"-- Lote {batch_num // batch_size + 1} (transacciones {batch_num + 1}-{min(batch_num + batch_size, len(transacciones))})")
        sql_lines.append("INSERT INTO Pagos_QR (payment_id, cliente_id, comercio_id, monto, fecha, estado, descripcion, metodo_pago, ip_origen, dispositivo) VALUES")

        for i, txn in enumerate(batch):
            payment_id, cliente_id, comercio_id, monto, fecha, estado, descripcion, metodo_pago, ip_origen, dispositivo = txn
            fecha_str = fecha.strftime('%Y-%m-%d %H:%M:%S')
            comma = "," if i < len(batch) - 1 else ";"
            sql_lines.append(
                f"('{payment_id}', {cliente_id}, {comercio_id}, {monto}, '{fecha_str}', "
                f"'{estado}', '{descripcion}', '{metodo_pago}', '{ip_origen}', '{dispositivo}'){comma}"
            )
        sql_lines.append("")

    sql_lines.extend([
        "-- " + "=" * 77,
        "-- PASO 4: ACTUALIZAR ESTADÍSTICAS",
        "-- " + "=" * 77,
        "",
        "ANALYZE TABLE Pagos_QR;",
        "ANALYZE TABLE Cuentas;",
        "ANALYZE TABLE Comercios;",
        "",
        "-- " + "=" * 77,
        "-- PASO 5: VERIFICACIÓN DE DATOS",
        "-- " + "=" * 77,
        "",
        "SELECT",
        "    '✅ DATOS GENERADOS EXITOSAMENTE' AS resultado,",
        "    (SELECT COUNT(*) FROM Pagos_QR) AS total_transacciones,",
        "    (SELECT COUNT(*) FROM Comercios) AS total_comercios,",
        "    (SELECT COUNT(*) FROM Cuentas WHERE id <= 128) AS total_clientes,",
        "    (SELECT MIN(fecha) FROM Pagos_QR) AS fecha_min,",
        "    (SELECT MAX(fecha) FROM Pagos_QR) AS fecha_max;",
        "",
        "-- Distribución por estado",
        "SELECT estado, COUNT(*) AS cantidad,",
        "       CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Pagos_QR), 2), '%') AS porcentaje",
        "FROM Pagos_QR",
        "GROUP BY estado",
        "ORDER BY cantidad DESC;",
        "",
        "-- Distribución por mes",
        "SELECT",
        "    DATE_FORMAT(fecha, '%Y-%m') AS mes,",
        "    COUNT(*) AS transacciones,",
        "    ROUND(SUM(monto), 2) AS total_monto",
        "FROM Pagos_QR",
        "GROUP BY DATE_FORMAT(fecha, '%Y-%m')",
        "ORDER BY mes;",
        "",
        "-- " + "=" * 77,
        "-- CONSULTAS SUGERIDAS PARA PE-1.4",
        "-- " + "=" * 77,
        "",
        "-- Consulta 1: SELECT simple (probar índice en monto)",
        "-- EXPLAIN SELECT * FROM Pagos_QR WHERE monto > 25.00;",
        "",
        "-- Consulta 2: JOIN (analizar índices FK)",
        "-- EXPLAIN SELECT p.*, c.titular, co.nombre",
        "-- FROM Pagos_QR p",
        "-- JOIN Cuentas c ON p.cliente_id = c.id",
        "-- JOIN Comercios co ON p.comercio_id = co.id",
        "-- WHERE p.fecha >= '2024-12-01';",
        "",
        "-- Consulta 3: GROUP BY (observar Using temporary/filesort)",
        "-- EXPLAIN SELECT comercio_id, COUNT(*), SUM(monto)",
        "-- FROM Pagos_QR",
        "-- WHERE estado = 'CONFIRMADO'",
        "-- GROUP BY comercio_id",
        "-- ORDER BY SUM(monto) DESC;",
    ])

    return "\n".join(sql_lines)


def main():
    """Función principal"""
    print("=" * 80)
    print("GENERADOR DE DATOS PARA PRÁCTICA PE-1.4")
    print("Semana 4: Optimización de Consultas - MySQL 8.0")
    print("=" * 80)
    print()

    # Generar SQL
    print(f"Configuración:")
    print(f"  - Transacciones a generar: {NUM_TRANSACCIONES:,}")
    print(f"  - Período: {FECHA_INICIO.strftime('%Y-%m-%d')} a {FECHA_FIN.strftime('%Y-%m-%d')}")
    print(f"  - Comercios nuevos: {len(COMERCIOS_ECUADOR)}")
    print()

    sql_content = generar_sql_completo()

    # Guardar archivo
    output_file = "02_datos_masivos_generados.sql"
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(sql_content)

    print()
    print("=" * 80)
    print(f"✅ Archivo generado exitosamente: {output_file}")
    print(f"   Tamaño: {len(sql_content) / 1024 / 1024:.2f} MB")
    print()
    print("Instrucciones de uso:")
    print("  1. Abre MySQL Workbench")
    print("  2. Conecta a tu base de datos")
    print(f"  3. Ejecuta: SOURCE {output_file};")
    print("  4. Espera ~2-3 minutos para la carga completa")
    print("=" * 80)


if __name__ == "__main__":
    main()
