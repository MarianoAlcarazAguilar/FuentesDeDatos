# Vamos a abrir el archivo y a limpiarlo
import re
import string

text = "123 hola..."
lines = re.sub(rf"([0-9]|[{string.punctuation}])", "", text)

print(lines)
