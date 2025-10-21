#!/bin/bash

# Script para consolidar estilos CSS en el proyecto HCI
# Elimina CSS embebido y reemplaza con referencia al archivo centralizado

echo "Iniciando consolidación de estilos CSS..."

# Función para procesar archivos de semanas
process_week_files() {
    local base_dir="/mnt/d/UIDE/HCI/semanas"
    
    # Buscar todos los archivos HTML de compendios (no BACKUP ni OLD)
    for file in $(find "$base_dir" -name "compendio-hci-semana*.html" | grep -v "BACKUP" | grep -v "OLD"); do
        echo "Procesando: $file"
        
        # Crear archivo temporal
        temp_file="${file}.tmp"
        
        # Usar sed para eliminar desde "<!-- Custom CSS" hasta "</style>"
        sed '/<!-- Custom CSS for A4 format and UIDE colors - Book-like design -->/,/<\/style>/c\
    <!-- UIDE Theme CSS -->\
    <link rel="stylesheet" href="../../assets/css/uide-theme.css">' "$file" > "$temp_file"
        
        # Verificar que el reemplazo funcionó
        if grep -q "uide-theme.css" "$temp_file"; then
            mv "$temp_file" "$file"
            echo "✓ Actualizado: $file"
        else
            echo "✗ Error al procesar: $file"
            rm "$temp_file"
        fi
    done
}

# Ejecutar función
process_week_files

echo "Consolidación completada."