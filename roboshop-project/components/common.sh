LOG_FILE=/tmp/roboshop.log

rm -f $LOG_FILE

STAT() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[1;32m Success\e[0m"
  else
    echo -e "\e[1;31m Failed\e[0m"
    exit 2
  fi
}