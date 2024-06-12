#!/bin/bash

# Comprobamos que se han pasado los argumentos necesarios
if [ "$#" -ne 3 ]; then
    echo "Uso: $0 archivo.c variable_antigua variable_nueva"
    exit 1
fi

# Asignamos los argumentos a variables
archivo="$1"
variable_antigua="$2"
variable_nueva="$3"

# Comprobamos si el archivo existe
if [ ! -f "$archivo" ]; then
    echo "El archivo $archivo no existe."
    exit 1
fi

# Hacemos una copia de seguridad del archivo original
cp "$archivo" "$archivo.bak"

# Reemplazamos todas las ocurrencias de la variable antigua por la nueva
sed -i "s/\b$variable_antigua\b/$variable_nueva/g" "$archivo"

echo "Se ha cambiado el nombre de la variable $variable_antigua a $variable_nueva en $archivo."
echo "Se ha creado una copia de seguridad en $archivo.bak."
