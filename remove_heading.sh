#!/bin/sh
# Comprobar si se proporcionaron los argumentos necesarios
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <ruta_archivo_c>"
    exit 1
fi

FILE="$1"

#Comprobamos si el FILE existe
if [ ! -f "$FILE" ]; then
    echo "El archivo $FILE no existe."
    exit 1
fi

tail -n +13 "$FILE" | tee "$FILE" > /dev/null
