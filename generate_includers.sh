#!/bin/bash

# Comprobar si se proporcionaron los argumentos necesarios
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <nombre_del_archivo_h> <ruta_archivos_c>"
    exit 1
fi

# Nombre del archivo .h final
FINAL_H="$1"
# Ruta de los archivos .c
C_DIR="$2"
# Directorio donde se guardará el archivo .h
INCLUDERS_DIR="includers"

# Comprobar si la ruta de los archivos .c existe y es un directorio
if [ ! -d "$C_DIR" ]; then
    echo "Error: La ruta especificada para los archivos .c no es un directorio válido."
    exit 1
fi

# Buscar archivos .c en la ruta especificada
C_FILES=$(find "$C_DIR" -name "*.c")
if [ -z "$C_FILES" ]; then
    echo "Error: No se encontraron archivos .c en el directorio especificado."
    exit 1
fi

# Crear la carpeta includers si no existe
if [ ! -d "$INCLUDERS_DIR" ]; then
    mkdir "$INCLUDERS_DIR"
    echo "Created directory $INCLUDERS_DIR"
fi

# Ruta completa del archivo .h final
FINAL_H_PATH="$INCLUDERS_DIR/$FINAL_H"

# Eliminar el archivo .h existente si existe
if [ -f "$FINAL_H_PATH" ]; then
    rm "$FINAL_H_PATH"
    echo "Deleted existing file $FINAL_H_PATH"
fi

# Función para extraer las declaraciones de funciones de un archivo .c
extract_function_declarations() {
    local c_file="$1"
    grep -P '^\w+\s+\w+\(.*\)' "$c_file" | awk '{
        type = $1
        name = $2
        gsub(/\(.*/, "", name)
        args = substr($0, index($0, "("))
        print type "\t" name args ";"
    }'
}

# Crear el archivo .h final
{
    echo "#ifndef $(echo "$FINAL_H" | tr 'a-z.' 'A-Z_')"
    echo "# define $(echo "$FINAL_H" | tr 'a-z.' 'A-Z_')"
    echo ""

    for c_file in $C_FILES; do
        echo "// Declarations from $(basename "$c_file")"
        declarations=$(extract_function_declarations "$c_file")
        echo "$declarations"
        echo ""
    done

    echo "#endif $(echo "$FINAL_H" | tr 'a-z.' 'A-Z_')"
} > "$FINAL_H_PATH"

echo "Generated $FINAL_H_PATH with all function declarations"

# Verificar e incluir la directiva #include en los archivos .c si es necesario
h_include="#include \"$FINAL_H\""
for c_file in $C_FILES; do
    if ! grep -q "$h_include" "$c_file"; then
        # Insertar la directiva #include después del heading de 12 líneas
        tmp_file=$(mktemp)
        head -n 11 "$c_file" > "$tmp_file"
        echo "" >> "$tmp_file"
        echo "$h_include" >> "$tmp_file"
        tail -n +13 "$c_file" >> "$tmp_file"
        mv "$tmp_file" "$c_file"
        echo "Added $h_include to $c_file"
    fi
done
