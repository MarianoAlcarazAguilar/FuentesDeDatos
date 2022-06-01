#! /home/user/anaconda3/bin/python

from bs4 import BeautifulSoup
import numpy as np
import requests
import sys

inputs = sys.argv
destination_folder = inputs[1]

url = "https://www.gutenberg.org/browse/languages/"
idiomas = ['es', 'fr']

for idioma in idiomas:
    print(f'Getting books in: {idioma}')
    url_aux = url + idioma
    result = requests.get(url_aux).text
    doc = BeautifulSoup(result, 'html.parser')
    content = doc.find('div', class_='pgdbbylanguage')

    file = open(f"{destination_folder}/{idioma}.txt", "w")

    # En authors tenemos una lista con los libros por autor
    authors = content.find_all('ul')

    for author in authors:
        # En books tenemos los libros de cada autor
        books = author.find_all('a')

        for book in books:
            link = book['href']
            file.write(link)
            file.write("\n")

    file.close()

# Ahora sacamos los libros en inglés
print("Getting books in: en")

bookshelf_pre_url = 'https://www.gutenberg.org/ebooks/bookshelf/'
book_pre_link = 'https://www.gutenberg.org'

file = open(f"{destination_folder}/en.txt", "w")

for i in np.arange(10, 100, 3):
    bookshelf_url = bookshelf_pre_url + str(i)
    result = requests.get(bookshelf_url).text
    doc = BeautifulSoup(result, 'html.parser')

    # En books tenemos todos los libros de una bookshelf
    books = doc.find_all('li', class_='booklink')

    for book in books:
        book_link = book.find('a')['href']
        file.write(book_link)
        file.write("\n")

file.close()