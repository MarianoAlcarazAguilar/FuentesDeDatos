#! /bin/bash

current_dir=$(pwd)

#echo "Start again?"
#read start
#while [ "$start" != "y" ] && [ "$start" != "n" ]
#do
#    echo "Please answer: (y/n)"
#    read start
#done
#if [ "$start" = "y" ]
#then
#  rm -r "$current_dir/wordle_env"
#fi

# ----------------------------------------------
# ASKING IF WE WANT TO MAKE THE ENVIRONMENT
# ----------------------------------------------
echo "Do you want to setup an environment? (y/n)"
read set_env
while [ "$set_env" != "y" ] && [ "$set_env" != "n" ]
do
    echo 'ENV'
    echo "$set_env"
    echo "Please answer: (y/n)"
    read set_env
done

# ----------------------------------------------
# IF YES
# ----------------------------------------------
if [ "$set_env" = "y" ]
then
    # ----------------------------------------------
    # ASK FOR LOCATION
    # ----------------------------------------------
    echo -e "Choose a location for project setup: (default: $current_dir)"
    echo -e "If you don't enter anything it will be default"
    read new_dir
    while [ 1 ]
    do
        if [ -z "$new_dir" ]
        then
            new_dir=$current_dir
        else
            while [[ ! -d "$new_dir" ]]
            do
                echo -e "The given path is wrong, please enter a valid one"
                read new_dir
                if [ -z "$new_dir" ]
                then
                    new_dir=$current_dir
                fi
            done
        fi
        
        # ----------------------------------------------
        # VERIFY THE DIRECTORY DOESN'T EXIST
        # ----------------------------------------------
        if [ -d "$new_dir/wordle_env" ] 
        then
            echo "The directory already exists, do you wish to replace it (y/n)"
            read remove
            if [ "$remove" = 'y' ]
            then
                rm -r "$new_dir/wordle_env"
                break
            else
                new_dir='NAN'
            fi
        else
            break
        fi
    done

    # ----------------------------------------
    # Create directory structure
    # ----------------------------------------
    echo "Creating directory project: $new_dir/wordle_env"
    mkdir "$new_dir/wordle_env"
    mkdir "$new_dir/wordle_env/auxiliares"
    mkdir "$new_dir/wordle_env/links"
    mkdir "$new_dir/wordle_env/books"
    mkdir "$new_dir/wordle_env/books/english_books"
    mkdir "$new_dir/wordle_env/books/french_books"
    mkdir "$new_dir/wordle_env/books/spanish_books"
    mkdir "$new_dir/wordle_env/results"
fi
# Llegando a este punto ya tenemos la carpeta wordle_env creada, con nada adentro

# Mandamos llamar al script de python a ver si funciona
# Le mandamos la ubicación de la carpeta para agregar los urls

# ----------------------------------------
# MAKE SURE NEW_DIR ISN'T EMPTY
# ----------------------------------------
if [ -z "$new_dir" ]
then
    new_dir=$current_dir
fi

# ----------------------------------------
# GET THE URLS OF THE BOOKS TO TEST
# ----------------------------------------
echo -e "\n---------------------Getting the urls of the books---------------------"
./scripts/get_book_urls.py "$new_dir/wordle_env/auxiliares"

# ----------------------------------------
# CLEANING THE URLS
# ----------------------------------------
ingles="$new_dir/wordle_env/auxiliares/en.txt"
espanol="$new_dir/wordle_env/auxiliares/es.txt"
frances="$new_dir/wordle_env/auxiliares/fr.txt"

echo -e "\n---------------------------Cleaning the urls---------------------------"
./scripts/clean_urls.sh "$ingles" "$espanol" "$frances" "$new_dir/wordle_env/links"


# ----------------------------------------
# GETTING THE BOOKS
# ----------------------------------------
echo -e "\n---------------------------Getting the books---------------------------"
echo "Do you want to download the books?"
read download
while [ "$download" != "y" ] && [ "$download" != "n" ]
do
    echo "Please answer: (y/n)"
    read download
done
if [ "$download" = "y" ]
then
  # shellcheck disable=SC2002
  max_books=$(cat "$ingles" | awk 'END {print NR}')
  echo -e "\nHow many books do you want to download? (max: $max_books)"
  read n_books
  ./scripts/get_books.py "$n_books" "$new_dir/wordle_env/books" "$new_dir/wordle_env/links"
fi

# ----------------------------------------
# GETTING LIST OF WORDS
# ----------------------------------------
echo -e "\n-------------------------Getting lists of words------------------------"
books_folder="$new_dir/wordle_env/books"
results="$new_dir/wordle_env/results"
./scripts/clean_books.sh "$books_folder" "$results"

sleep 0.3
echo -e "\nEverything is done"


