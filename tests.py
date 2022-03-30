import re
import string
import numpy as np
import pandas as pd
import os

'''
This function parses each input line:
- sets every word into lowercase
- remove non words (except single white space)
- remove empty lines
- returns a list of words.
:param line: the line to process
:return: processed line
'''

# Abrimos las stopwords
with open('stopwords.txt') as f:
    sw = f.readlines()

sw = [re.sub("\n", "", x) for x in sw]


def test(text):
    return re.sub(f"[{string.punctuation}]+", "", text).split()


with open('main_text000.txt') as f:
    # Esto devuelve una lista de Strings
    lines = f.readlines()

# Tenemos que quitar las "\n"
lines = [re.sub(r"\n", "", x).lower() for x in lines]
lines = [f"START {x} END" for x in lines]
lines = [test(x) for x in lines]

dict = {}
for line in lines:
    for word in line:
        if word not in sw:
            try:
                dict[word] += 1
            except:
                dict[word] = 1
sort_orders = sorted(dict.items(), key=lambda x: x[1], reverse=True)

# Agregamos a un diccionario las primeras 25 palabras
minSize = min(50, len(sort_orders))
top_words = {}
other_top_words = {}
for i in range(minSize):
    top_words[i] = sort_orders[i][0]
    other_top_words[sort_orders[i][0]] = i

# Esta es la lista de las palabras sobre las que vamos a trabajar
words_list = list(other_top_words.keys())
print(len(other_top_words))

# Ahora necesitamos el texto para hacerle el análisis
# solo queremos las palabras dentro de las words_list

# Vamos a hacer un diccionario con las palabras y con su correspondiente
dict_ceros = {}

for word in words_list:
    dict_ceros[word] = np.zeros(len(words_list))

# Nos movemos sobre cada renglón
window_size = 1/2
for linea in lines:

    # Nos movemos sobre las palabras de el renglón
    for i in range(len(linea)):

        # Si la palabra está dentro de las más frecuentes hacemos el análisis
        if linea[i] in words_list:

            # Buscamos 4 letras a la derecha

            for k in range(int(2*window_size)):

                # j es la palabra en la lista del lado derecho
                j = k + i + 1

                # m es la palabra en la lista del lado izquierdo
                m = i - k - 1

                if m >= 0:
                    if linea[m] in words_list:
                        index = other_top_words[linea[m]]
                        # Si queremos que tome en cuenta la distancia entonces dividimos el 1 entre k+1
                        dict_ceros[linea[i]][index] += 1

                if j < len(linea):
                    # Si la palabra está en las deseadas, agregamos uno a la lista de ceros de la palabra i
                    if linea[j] in words_list:
                        index = other_top_words[linea[j]]
                        # Si queremos que tome en cuenta la distancia entonces dividimos el 1 entre k+1
                        dict_ceros[linea[i]][index] += 1

# Ahora lo convertimos a una matriz
matriz = np.zeros(len(words_list))

for word in dict_ceros.keys():
    matriz = np.vstack((matriz, dict_ceros[word]))

matriz = np.delete(matriz, 0, axis=0)

# Tenemos que hacer una matriz que se llame expected
# en la entrada ij tiene un promedio de la siguiente forma:
# suma de la fila i * suma de la columna j / (suma de la fila i + suma de la columna j)

# Row, column
size = len(words_list)
expected = np.zeros((size, size))
total = sum(sum(matriz))
for i in range(size):
    for j in range(size):
        suma_i = sum(matriz[i])
        suma_j = sum(matriz[:, j])
        expected[i,j] = (suma_i * suma_j)/total

with np.errstate(divide='ignore'):
    log_vals = np.log(matriz / expected)
matriz = np.maximum(log_vals, 0)
matriz = pd.DataFrame(matriz)

print(os.listdir("/home/user/Documents/project_1/text_comp"))
print(os.path.join("hola"))