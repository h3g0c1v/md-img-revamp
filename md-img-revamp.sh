#!/usr/bin/bash

# Definición de colores para estilizar las salidas
green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"

# Manejo de interrupción con Ctrl + C
function ctrl_c() {
  echo -e "\n${red}[✖] Saliendo del script...${end}\n"
  exit 1
}
trap ctrl_c SIGINT

# Mostrar panel de ayuda
function helpPanel() {
  echo -e "\n${green}[ℹ]${end} ${blue}Uso:${end} ${yellow}$0 fichero.md [ruta_imagenes] [ruta_renombrar]${end}"
  echo -e "\n${green}Descripción:${end} Este script modifica y renombra imágenes en un archivo markdown, adaptándolas a un formato estándar."
}

# Validar existencia de archivo y ruta
function validateFile() {
  # Verifica si el archivo existe
  if [ ! -f "$file" ]; then
    echo -e "\n${red}[✖] El archivo especificado no existe: ${yellow}$file${end}\n"
    exit 1
  fi

  if [ $pathToRename != "." ]; then
    # Verifica si la ruta para renombrar existe
    if [ ! -d "$pathToRename" ]; then
      echo -e "\n${red}[✖] La ruta especificada no existe: ${yellow}$pathToRename${end}\n"
      exit 1
    fi
  fi
}

# Obtener y listar imágenes en el archivo markdown
function obtainImages() {
  # Extraer las imágenes encontradas
  mapfile -t images < <(grep -iE '!\[\[.*\]\]' "$file")

  echo -e "\n${green}[ℹ]${end} ${blue}Imágenes encontradas en el archivo:${end}\n"

  declare -i counter=0
  for item in "${images[@]}"; do
    echo -e "\t- ${turquoise}${item}${end}" | sed "s/!\[\[//g" | sed "s/\]\]//g"
    counter+=1
  done

  if [ $counter -gt 0 ]; then
    while true; do
      echo -ne "\n${yellow}[?]${end} ¿Quieres modificar los nombres de las imágenes? [S/n]: " && read modify
    
      case "$modify" in
        S|s) break;;
        N|n) echo -e "\n${red}[✖] Operación cancelada por el usuario.${end}" && exit 1;;
        *) echo -ne "\n${red}[!] Por favor, introduce S o N.${end}\n";;
      esac
    done
  else
    echo -e "\n${green}[✔] El formato del archivo ya es correcto.${end}"
    exit 0
  fi
}

# Renombrar imágenes dentro del archivo markdown
function renameImagesFile() {
  echo
  for item in "${images[@]}"; do
    imageToRename=$item
    escapedImageToRename=$(printf '%s' "$imageToRename" | sed 's/[][\&/|$.*^]/\\&/g')
    newImageWithHyphen=$(echo "$imageToRename" | tr -d '!\[\]' | sed "s/  */-/g")

    newImageName=$(echo "$item" | sed "s/\[\[/\[/g" | sed "s|\]\]|]($pathToSave$newImageWithHyphen)|g")
    escapedNewImageName=$(printf '%s' "$newImageName" | sed 's/[][\&/|$.*^]/\\&/g')

    sed -i "s|$escapedImageToRename|$escapedNewImageName|g" "$file"
    
    echo -e "${green}[✔]${end} ${gray}Renombrado:${end} ${turquoise}$imageToRename${end} ➜ ${purple}$newImageName${end}"

    grep -qF "$newImageName" "$file" &>/dev/null && \
      echo -e "${green}[✔]${end} ${gray}Cadena modificada correctamente.${end}" || \
      echo -e "${red}[✖]${end} ${gray}Error al modificar la cadena: ${yellow}$newImageName${end}"
  done
}

# Renombrar archivos de imágenes en el directorio
function renameImages() {
  pushd "$pathToRename" &>/dev/null

  for archivo in *; do
    if [[ "$archivo" == *" "* ]]; then
      nuevo_nombre=$(echo "$archivo" | tr ' ' '-')
      mv "$archivo" "$nuevo_nombre"
      echo -e "${green}[✔]${end} ${gray}Archivo renombrado:${end} ${turquoise}$archivo${end} ➜ ${purple}$nuevo_nombre${end}"
    fi
  done

  popd &>/dev/null
}

# Función principal
if [ $1 ]; then
  file=$1
  pathToSave="/assets/img/"
  pathToRename="."
  
  if [ "$2" ]; then
    pathToSave=$2
  fi

  if [ "$3" ]; then
    pathToRename="$3"
  fi

  validateFile
  obtainImages "$file"
  renameImagesFile
  renameImages "$pathToSave"

else
  helpPanel
fi
