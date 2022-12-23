#! /bin/bash

ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo -e "\e[1;31m You should be root user to execute this script..\e[0m"
  exit 1
fi

if [ -f components/$1.sh ]; then
  bash components/$1.sh
else
  echo -e "\e[1;31m Invalid inputs\e[0m"
  echo -e "\e[1;32mAvailable Inputs frontend|cart|catalogue|dispatch|mongodb|mysql|payment|rabbitmq|redis|shipping|user\e[0m"
  exit 1
fi