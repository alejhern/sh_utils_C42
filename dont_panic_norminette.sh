#!/bin/bash

# Comandos para ejecutar norminette y clang-format
norminette_cmd="norminette"
clang_format_cmd="clang-format"

# Función para imprimir separador
print_separator() {
    printf "\n================================================================\n\n"
}

# Verificar si norminette está instalado
if ! command -v $norminette_cmd > /dev/null; then
    echo "Error: norminette no está instalado. Por favor, instálalo para continuar."
    exit 1
fi

# Verificar si clang-format está instalado
if ! command -v $clang_format_cmd &> /dev/null; then
    echo "Error: clang-format no está instalado. Por favor, instálalo para continuar."
    exit 1
fi

# Función para formatear el archivo usando clang-format
format_file() {
    file=$1
    $clang_format_cmd -style=llvm -i $file
}

# Función para verificar si el archivo existe y es un archivo C válido
is_valid_file() {
    file=$1
    if [[ -f $file && $file == *.c ]]; then
        return 0
    else
        return 1
    fi
}

# Obtener lista de archivos a procesar
if [ $# -eq 0 ]; then
    # No se proporcionaron archivos, buscar todos los archivos .c en el directorio actual
    files=$(find . -name "*.c")
    files_array=($files)
else
    # Usar los archivos proporcionados como argumentos
    files=$@
    files_array=()
    for file in $files; do
        if is_valid_file $file; then
            files_array+=($file)
        else
            echo "Advertencia: $file no es un archivo válido o no es un archivo C. Omitiendo."
        fi
    done
fi

# Verificar y formatear cada archivo
for file in "${files_array[@]}"; do
    echo "Verificando y formateando el archivo: $file"
    print_separator
    $norminette_cmd $file
    print_separator
    format_file $file
    print_separator
done

echo "Verificación y formateo completados."
