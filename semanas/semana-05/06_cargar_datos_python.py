#!/usr/bin/env python3
"""
Script de Carga de Datos - Programa de Lealtad de Aerolínea
Curso: Sistemas de Gestión de Bases de Datos (SGBD-ASC)
Semana: 05

Descripción:
    Script Python alternativo para cargar datos CSV a MySQL cuando
    LOAD DATA INFILE no está disponible o presenta problemas.

Requisitos:
    pip install mysql-connector-python pandas

Uso:
    python 06_cargar_datos_python.py
"""

import mysql.connector
import pandas as pd
import os
from datetime import datetime
import sys

# ============================================================================
# CONFIGURACIÓN
# ============================================================================

# Configuración de conexión a MySQL
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': '',  # CAMBIAR ESTO
    'database': 'airline_loyalty_db',
    'charset': 'utf8mb4',
    'use_unicode': True
}

# Rutas de los archivos CSV (AJUSTAR SEGÚN TU SISTEMA)
CSV_FILES = {
    'calendar': 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Calendar.csv',
    'customer_loyalty': 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customer Loyalty History.csv',
    'flight_activity': 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customer Flight Activity.csv'
}

# Tamaño de lote para inserciones (ajustar según memoria disponible)
BATCH_SIZE = 1000

# ============================================================================
# FUNCIONES AUXILIARES
# ============================================================================

def print_header(message):
    """Imprime un encabezado formateado"""
    print("\n" + "=" * 80)
    print(f" {message}")
    print("=" * 80)

def print_progress(current, total, prefix='Progreso'):
    """Imprime una barra de progreso"""
    percent = 100 * (current / float(total))
    bar_length = 50
    filled = int(bar_length * current // total)
    bar = '█' * filled + '-' * (bar_length - filled)
    print(f'\r{prefix}: |{bar}| {percent:.1f}% ({current}/{total})', end='', flush=True)
    if current == total:
        print()

def verificar_archivos():
    """Verifica que todos los archivos CSV existan"""
    print_header("Verificando archivos CSV")
    
    archivos_faltantes = []
    for nombre, ruta in CSV_FILES.items():
        if os.path.exists(ruta):
            size_mb = os.path.getsize(ruta) / (1024 * 1024)
            print(f"✓ {nombre}: {ruta} ({size_mb:.2f} MB)")
        else:
            print(f"✗ {nombre}: {ruta} - NO ENCONTRADO")
            archivos_faltantes.append(nombre)
    
    if archivos_faltantes:
        print(f"\nError: Faltan {len(archivos_faltantes)} archivo(s)")
        print("Por favor, ajusta las rutas en CSV_FILES")
        return False
    
    return True

def crear_conexion():
    """Crea y retorna una conexión a MySQL"""
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        print(f"✓ Conectado a MySQL: {DB_CONFIG['host']}")
        return conn
    except mysql.connector.Error as err:
        print(f"✗ Error de conexión: {err}")
        sys.exit(1)

def crear_base_datos(conn):
    """Crea la base de datos y las tablas"""
    print_header("Creando base de datos y tablas")
    
    cursor = conn.cursor()
    
    # Leer y ejecutar el script SQL de creación
    try:
        with open('01_crear_base_datos_airline_loyalty.sql', 'r', encoding='utf-8') as f:
            sql_script = f.read()
            
        # Dividir por punto y coma y ejecutar cada comando
        for statement in sql_script.split(';'):
            statement = statement.strip()
            if statement and not statement.startswith('--'):
                try:
                    cursor.execute(statement)
                except mysql.connector.Error as err:
                    # Ignorar algunos errores comunes
                    if 'already exists' not in str(err).lower():
                        print(f"Advertencia: {err}")
        
        conn.commit()
        print("✓ Base de datos y tablas creadas exitosamente")
        
    except FileNotFoundError:
        print("Advertencia: No se encontró 01_crear_base_datos_airline_loyalty.sql")
        print("Asegúrate de que la base de datos ya existe")
    except Exception as e:
        print(f"Error al crear base de datos: {e}")
        sys.exit(1)
    
    cursor.close()

def cargar_calendar(conn):
    """Carga datos de la tabla calendar"""
    print_header("Cargando datos de Calendar")
    
    # Leer CSV
    df = pd.read_csv(CSV_FILES['calendar'])
    print(f"Registros leídos: {len(df)}")
    
    # Preparar datos
    df['Date'] = pd.to_datetime(df['Date'])
    df['year_num'] = df['Date'].dt.year
    df['quarter_num'] = df['Date'].dt.quarter
    df['month_num'] = df['Date'].dt.month
    df['day_of_week'] = df['Date'].dt.day_name()
    
    # Insertar en lotes
    cursor = conn.cursor()
    
    insert_query = """
        INSERT INTO calendar 
        (date_id, start_of_year, start_of_quarter, start_of_month, 
         year_num, quarter_num, month_num, day_of_week)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    """
    
    total_rows = len(df)
    for i in range(0, total_rows, BATCH_SIZE):
        batch = df.iloc[i:i+BATCH_SIZE]
        
        values = [
            (
                row['Date'],
                row['Start of Year'],
                row['Start of Quarter'],
                row['Start of Month'],
                row['year_num'],
                row['quarter_num'],
                row['month_num'],
                row['day_of_week']
            )
            for _, row in batch.iterrows()
        ]
        
        cursor.executemany(insert_query, values)
        conn.commit()
        
        print_progress(min(i + BATCH_SIZE, total_rows), total_rows, 'Insertando')
    
    cursor.close()
    print(f"✓ {total_rows} registros insertados en calendar")

def cargar_customer_loyalty(conn):
    """Carga datos de la tabla customer_loyalty_history"""
    print_header("Cargando datos de Customer Loyalty History")
    
    # Leer CSV
    df = pd.read_csv(CSV_FILES['customer_loyalty'])
    print(f"Registros leídos: {len(df)}")
    
    # Reemplazar valores vacíos con None
    df = df.where(pd.notnull(df), None)
    
    # Insertar en lotes
    cursor = conn.cursor()
    
    insert_query = """
        INSERT INTO customer_loyalty_history 
        (loyalty_number, country, province, city, postal_code, gender, 
         education, salary, marital_status, loyalty_card, clv, 
         enrollment_type, enrollment_year, enrollment_month, 
         cancellation_year, cancellation_month)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """
    
    total_rows = len(df)
    for i in range(0, total_rows, BATCH_SIZE):
        batch = df.iloc[i:i+BATCH_SIZE]
        
        values = [
            (
                row['Loyalty Number'],
                row['Country'],
                row['Province'],
                row['City'],
                row['Postal Code'],
                row['Gender'],
                row['Education'],
                row['Salary'],
                row['Marital Status'],
                row['Loyalty Card'],
                row['CLV'],
                row['Enrollment Type'],
                row['Enrollment Year'],
                row['Enrollment Month'],
                row['Cancellation Year'],
                row['Cancellation Month']
            )
            for _, row in batch.iterrows()
        ]
        
        cursor.executemany(insert_query, values)
        conn.commit()
        
        print_progress(min(i + BATCH_SIZE, total_rows), total_rows, 'Insertando')
    
    cursor.close()
    print(f"✓ {total_rows} registros insertados en customer_loyalty_history")

def cargar_flight_activity(conn):
    """Carga datos de la tabla customer_flight_activity"""
    print_header("Cargando datos de Customer Flight Activity")
    print("ADVERTENCIA: Este proceso puede tardar varios minutos...")
    
    # Leer CSV en chunks para manejar el tamaño
    chunk_size = 10000
    total_inserted = 0
    
    cursor = conn.cursor()
    
    insert_query = """
        INSERT INTO customer_flight_activity 
        (loyalty_number, year, month, total_flights, distance, 
         points_accumulated, points_redeemed, dollar_cost_points_redeemed)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    """
    
    # Procesar en chunks
    for chunk_num, chunk in enumerate(pd.read_csv(CSV_FILES['flight_activity'], chunksize=chunk_size)):
        values = [
            (
                row['Loyalty Number'],
                row['Year'],
                row['Month'],
                row['Total Flights'],
                row['Distance'],
                row['Points Accumulated'],
                row['Points Redeemed'],
                row['Dollar Cost Points Redeemed']
            )
            for _, row in chunk.iterrows()
        ]
        
        cursor.executemany(insert_query, values)
        conn.commit()
        
        total_inserted += len(chunk)
        print(f"Chunk {chunk_num + 1}: {total_inserted} registros insertados", end='\r', flush=True)
    
    print()
    cursor.close()
    print(f"✓ {total_inserted} registros insertados en customer_flight_activity")

def verificar_carga(conn):
    """Verifica que los datos se hayan cargado correctamente"""
    print_header("Verificando carga de datos")
    
    cursor = conn.cursor()
    
    tablas = [
        ('calendar', 2559),
        ('customer_loyalty_history', 16739),
        ('customer_flight_activity', 392938)
    ]
    
    for tabla, esperado in tablas:
        cursor.execute(f"SELECT COUNT(*) FROM {tabla}")
        actual = cursor.fetchone()[0]
        
        status = "✓" if actual == esperado else "⚠"
        print(f"{status} {tabla}: {actual:,} registros (esperado: {esperado:,})")
    
    cursor.close()

# ============================================================================
# FUNCIÓN PRINCIPAL
# ============================================================================

def main():
    """Función principal"""
    print_header("Script de Carga de Datos - Airline Loyalty Program")
    print(f"Inicio: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    # Verificar archivos
    if not verificar_archivos():
        sys.exit(1)
    
    # Solicitar contraseña si no está configurada
    if not DB_CONFIG['password']:
        import getpass
        DB_CONFIG['password'] = getpass.getpass("Ingrese la contraseña de MySQL: ")
    
    # Crear conexión
    conn = crear_conexion()
    
    try:
        # Crear base de datos
        crear_base_datos(conn)
        
        # Cargar datos
        cargar_calendar(conn)
        cargar_customer_loyalty(conn)
        cargar_flight_activity(conn)
        
        # Verificar
        verificar_carga(conn)
        
        print_header("PROCESO COMPLETADO EXITOSAMENTE")
        print(f"Fin: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        
    except Exception as e:
        print(f"\n✗ Error durante la carga: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
    
    finally:
        conn.close()
        print("Conexión cerrada")

if __name__ == "__main__":
    main()
