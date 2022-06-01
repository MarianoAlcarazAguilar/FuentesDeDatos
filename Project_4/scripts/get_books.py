#! /home/user/anaconda3/bin/python

import requests
import sys
import os
import re
import string

# En $1 tenemos el total de libros a descargar
# En $2 tenemos el folder de destino
# En $3 tenemos el folder con los números de los libros

inputs = sys.argv
n_books = int(inputs[1])
destination_folder = inputs[2]
book_ids = inputs[3]

# Esta función se usa para limpiar el texto del libro
def clean_text(text):
    # Cambiamos el texto a lower y n't por not
    text = re.sub(r"n't", " not", text.lower())
    text = re.sub(rf"[^{string.ascii_lowercase}]", " ", text)
    return text




for file_name in os.listdir(book_ids):
    language = file_name.split('.')[0]
    print(language)
    i = 0
    with open(f'{book_ids}/{file_name}', 'r') as file:
        # En line está el número del libro
        for line in file:
            i += 1
            line = line.strip("\n")
            link = f"https://www.gutenberg.org/cache/epub/{line}/pg{line}.txt"
            print(link)
            book = requests.get(link).text
            book = clean_text(book)
            output = open(f"{destination_folder}/{language}/{line}.txt", 'w')
            output.write(book)
            output.close()
            if i == n_books:
                break