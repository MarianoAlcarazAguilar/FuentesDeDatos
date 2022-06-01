#! /bin/bash

# Este script recibe la carpeta donde están las carpetas de los libros por idioma, luego itera sobre cada carpeta
# y sobre cada libro para limpiarlo y manda el resultado a otra carpeta donde se quieran tener los resultados
# En $1 tenemos el path hasta books
# En $2 tenemos el path hasta results

books_folder="$1/*"
destination_folder=$2

# books_folder="/home/user/Documents/FuentesDeDatos/project_4/wordle_env/books/*"

# Iteramos sobre cada folder de los diferentes idiomas
for LANGUAGE_FOLDER in $books_folder
do
  # Sacamos el nombre del idioma
  IDIOMA=$(echo "$LANGUAGE_FOLDER" | awk -F '/' '{print $NF}')
  if [ "$IDIOMA" =  "english_books" ]
  then
    IDIOMA="en"
  else
    if [ "$IDIOMA" =  "french_books" ]
    then
      IDIOMA="fr"
    else
      IDIOMA="es"
    fi
  fi
  echo "Getting words in: $IDIOMA"
  # Ahora iteramos sobre cada libro del idioma
  lang_books="$LANGUAGE_FOLDER/*"
  for book in $lang_books
  do
    # shellcheck disable=SC2002
    cat "$book" | awk '{for(i=1; i<=NF; i++) {if(length($i)==5) print $i}}' >> "$destination_folder/$IDIOMA.txt"
  done

done


