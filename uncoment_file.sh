#!/bin/bash

# Comprobar si se proporcionaron los argumentos necesarios
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <ruta_archivo_c>"
    exit 1
fi

# Archivo de entrada
FILE="$1"

# Comprobar si el archivo de entrada existe
if [ ! -f "$FILE" ]; then
    echo "Error: El archivo de entrada no existe."
    exit 1
fi

# Copia del archivo con comentarios
echo "Se ha guardado una copia del archivo comentado en $FILE.coment"
cp "$FILE" "$FILE.coment"

# Guardar las primeras 12 líneas en el archivo de salida temporal
#head -n 12 "$FILE" > "$FILE.tmp"

# Eliminar los comentarios del fichero
sed -i -e "s#[[:space:]]*//.*##g" $FILE

# Mover el archivo temporal al archivo original
#mv "$FILE.tmp" "$FILE"

echo "Los comentarios de $FILE han sido eliminados!"
