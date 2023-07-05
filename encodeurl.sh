#!/bin/bash

# Lista de caracteres
characters=$(for ((i=32;i<127;i++)) do printf "\\$(printf %03o "$i")"; done)

# Função para realizar o URL encoding
urlencode() {
  local string="${1}"
  local length="${#string}"
  local encoded=""

  for (( i = 0; i < length; i++ )); do
    local c="${string:i:1}"
    case $c in
      [a-zA-Z0-9.~_-])
        encoded+="$c"
        ;;
      *)
        encoded+=$(printf '%%%02X' "'$c")
        ;;
    esac
  done

  echo "$encoded"
}

# Codifica cada caractere e cria a lista em Python
python_list="["
for (( i = 0; i < ${#characters}; i++ )); do
  char="${characters:i:1}"
  encoded_char=$(urlencode "$char")
  python_list+="\"$encoded_char\", "
done
python_list="${python_list%, }]"

echo "$python_list"
