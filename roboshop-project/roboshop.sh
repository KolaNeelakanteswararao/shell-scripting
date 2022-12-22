#! /bin/bash

if [ -f components/$1.sh ]; then
  bash components/$1.sh
else
  echo -e "\e[1;31m Invalid inputs\e[0m"
  echo -e "\e[1;32mAvailable Inputs frontend|cart|catalogue|dispatch|mongodb|mysql|payment|rabbitmq|redis|shipping|user\e[0m"
fi