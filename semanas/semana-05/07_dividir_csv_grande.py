#!/usr/bin/env python3
"""
Utilidad para Dividir Archivos CSV Grandes
Curso: Sistemas de Gestión de Bases de Datos (SGBD-ASC)
Semana: 05

Descripción:
    Script para dividir archivos CSV grandes en partes más pequeñas
    para facilitar la carga en sistemas con recursos limitados.

Uso:
    python 07_dividir_csv_grande.py
"""

import pandas as pd
import os
import sys

# ============================================================================
# CONFIGURACIÓN
# ============================================================================

# Archivo a dividir
INPUT_FILE = 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customer Flight Activity.csv'

# Número de filas por archivo (ajustar según necesidad)
ROWS_PER_FILE = 50000

# Directorio de salida
OUTPUT_DIR = 'csv_parts'

# ============================================================================
# FUNCIONES
# ============================================================================

def print_header(message):
    """Imprime un encabezado formateado"""
    print("\n" + "=" * 80)
    print(f" {message}")
    print("=" * 80)

def dividir_csv(input_file, rows_per_file, output_dir):
    """
    Divide un archivo CSV grande en partes más pequeñas
    
    Args:
        input_file: Ruta del archivo CSV a dividir
        rows_per_file: Número de filas por archivo de salida
        output_dir: Directorio donde guardar los archivos divididos
    """
    
    # Verificar que el archivo existe
    if not os.path.exists(input_file):
        print(f"Error: No se encontró el archivo {input_file}")
        sys.exit(1)
    
    # Crear directorio de salida si no existe
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
        print(f"✓ Directorio creado: {output_dir}")
    
    # Obtener información del archivo
    file_size_mb = os.path.getsize(input_file) / (1024 * 1024)
    print(f"Archivo de entrada: {input_file}")
    print(f"Tamaño: {file_size_mb:.2f} MB")
    
    # Leer el archivo en chunks
    print(f"\nDividiendo en archivos de {rows_per_file:,} filas cada uno...")
    
    chunk_num = 0
    total_rows = 0
    
    # Obtener el nombre base del archivo
    base_name = os.path.splitext(os.path.basename(input_file))[0]
    
    # Procesar en chunks
    for chunk in pd.read_csv(input_file, chunksize=rows_per_file):
        chunk_num += 1
        total_rows += len(chunk)
        
        # Nombre del archivo de salida
        output_file = os.path.join(output_dir, f"{base_name}_part{chunk_num}.csv")
        
        # Guardar el chunk
        chunk.to_csv(output_file, index=False)
        
        file_size = os.path.getsize(output_file) / (1024 * 1024)
        print(f"  Parte {chunk_num}: {output_file} ({len(chunk):,} filas, {file_size:.2f} MB)")
    
    print(f"\n✓ Proceso completado")
    print(f"  Total de filas procesadas: {total_rows:,}")
    print(f"  Archivos generados: {chunk_num}")
    print(f"  Ubicación: {os.path.abspath(output_dir)}")
    
    return chunk_num

def generar_script_carga(num_parts, output_dir):
    """
    Genera un script SQL para cargar todos los archivos divididos
    
    Args:
        num_parts: Número de partes generadas
        output_dir: Directorio donde están los archivos
    """
    
    script_file = os.path.join(output_dir, 'cargar_partes.sql')
    
    with open(script_file, 'w', encoding='utf-8') as f:
        f.write("-- Script generado automáticamente para cargar archivos divididos\n")
        f.write("-- Ajustar las rutas según tu sistema\n\n")
        f.write("USE airline_loyalty_db;\n\n")
        f.write("SET FOREIGN_KEY_CHECKS = 0;\n")
        f.write("SET UNIQUE_CHECKS = 0;\n")
        f.write("SET AUTOCOMMIT = 0;\n\n")
        
        for i in range(1, num_parts + 1):
            f.write(f"-- Parte {i} de {num_parts}\n")
            f.write(f"LOAD DATA INFILE '{output_dir}/Customer Flight Activity_part{i}.csv'\n")
            f.write("INTO TABLE customer_flight_activity\n")
            f.write("CHARACTER SET utf8mb4\n")
            f.write("FIELDS TERMINATED BY ',' \n")
            f.write("ENCLOSED BY '\"'\n")
            f.write("LINES TERMINATED BY '\\n'\n")
            f.write("IGNORE 1 ROWS\n")
            f.write("(\n")
            f.write("    loyalty_number,\n")
            f.write("    year,\n")
            f.write("    month,\n")
            f.write("    total_flights,\n")
            f.write("    distance,\n")
            f.write("    points_accumulated,\n")
            f.write("    points_redeemed,\n")
            f.write("    dollar_cost_points_redeemed\n")
            f.write(");\n\n")
        
        f.write("COMMIT;\n")
        f.write("SET FOREIGN_KEY_CHECKS = 1;\n")
        f.write("SET UNIQUE_CHECKS = 1;\n")
        f.write("SET AUTOCOMMIT = 1;\n\n")
        f.write("SELECT 'Carga completada' AS status;\n")
    
    print(f"\n✓ Script SQL generado: {script_file}")

def mostrar_instrucciones(output_dir):
    """Muestra instrucciones para usar los archivos divididos"""
    
    print_header("INSTRUCCIONES DE USO")
    
    print("""
Los archivos CSV han sido divididos exitosamente.

Para cargar los datos en MySQL:

OPCIÓN 1: Usar el script SQL generado
    1. Abrir el archivo 'cargar_partes.sql' en el directorio de salida
    2. Ajustar las rutas de los archivos según tu sistema
    3. Ejecutar el script en MySQL

OPCIÓN 2: Cargar manualmente cada parte
    1. Usar LOAD DATA INFILE para cada archivo part1.csv, part2.csv, etc.
    2. Asegurarse de usar IGNORE 1 ROWS para saltar el encabezado

OPCIÓN 3: Usar el script Python
    1. Modificar 06_cargar_datos_python.py para procesar los archivos divididos
    2. Ejecutar: python 06_cargar_datos_python.py

NOTA: Los archivos divididos están en el directorio:
    """ + os.path.abspath(output_dir))

# ============================================================================
# FUNCIÓN PRINCIPAL
# ============================================================================

def main():
    """Función principal"""
    print_header("Utilidad para Dividir Archivos CSV Grandes")
    
    try:
        # Dividir el archivo
        num_parts = dividir_csv(INPUT_FILE, ROWS_PER_FILE, OUTPUT_DIR)
        
        # Generar script de carga
        generar_script_carga(num_parts, OUTPUT_DIR)
        
        # Mostrar instrucciones
        mostrar_instrucciones(OUTPUT_DIR)
        
    except Exception as e:
        print(f"\n✗ Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == "__main__":
    main()
