#! /bin/bash

# En $1 tenemos el archivo con los links en inglés
# En $2 tenemos el archivo con los links en español
# En $3 tenemos el archivo con los links en francés
# En $4 tenemos la ubicación de dónde los vamos a meter

ingles=$1
espanol=$2
frances=$3

destination_dir=$4


echo -e "Cleaning books in english"
sleep 0.3
awk -F '/' '{print $3}' "$ingles" > "$destination_dir/english_books.txt"
echo -e "Cleaning books in spanish"
sleep 0.3
awk -F '/' '{print $3}' "$espanol" > "$destination_dir/spanish_books.txt"
echo -e "Cleaning books in french"
sleep 0.3
awk -F '/' '{print $3}' "$frances"> "$destination_dir/french_books.txt"