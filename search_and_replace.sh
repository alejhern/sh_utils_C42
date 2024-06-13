#!/bin/bash

# Comprobamos que se han pasado los argumentos necesarios
if [ "$#" -ne 3 ]; then
    echo "Uso: $0 <ruta_archivo.c> <search> <replace>"
    exit 1
fi

# Asignamos los argumentos a variables
FILE="$1"
SEARCH="$2"
REPLACE="$3"

# Comprobamos si el FILE existe
if [ ! -f "$FILE" ]; then
    echo "El archivo $FILE no existe."
    exit 1
fi

# Hacemos una copia de seguridad del FILE original
cp "$FILE" "$FILE.bak"

# Reemplazamos todas las ocurrencias antiguas por la nueva
sed -i "s/\b$SEARCH\b/$REPLACE/g" "$FILE"

echo "Se ha cambiado las ocurrencias $SEARCH a $REPLACE en $FILE."
echo "Se ha creado una copia de seguridad en $FILE.bak."
