LOG_FILE=/tmp/roboshop.log

rm -f $LOG_FILE

NODEJS() {
  COMPONENT=$1
  echo "Set up NodeJs Repo"
  curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -  &>>$LOG_FILE
  STAT $?

  echo "Installing NodeJs"
  yum install nodejs -y &>>$LOG_FILE
  STAT $?

  echo "create app user"
  id roboshop &>>$LOG_FILE
  if [ $? -ne 0 ]; then
     useradd roboshop &>>$LOG_FILE
  fi
  STAT $?

  echo "Download ${COMPONENT} code"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG_FILE
  STAT $?

  echo "Extract ${COMPONENT} code"
  cd /tmp/
  unzip  -o /tmp/${COMPONENT}.zip &>>$LOG_FILE
  STAT $?

  echo "clean ${COMPONENT} old content"
  rm -rf /home/roboshop/${COMPONENT}
  STAT $?

  echo "copy ${COMPONENT} content"
  cp -r ${COMPONENT}-main /home/roboshop/${COMPONENT} &>>$LOG_FILE
  STAT $?

  echo "install nodejs dependencies"
  cd /home/roboshop/${COMPONENT} &>>$LOG_FILE
  npm install -y &>>$LOG_FILE
  STAT $?

  chown roboshop:roboshop /home/roboshop -R

  echo "update systemD file"
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal' /home/roboshop/${COMPONENT}/systemd.service &>>$LOG_FILE
  STAT $?

  echo "setup ${COMPONENT} systemD file"
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>$LOG_FILE
  STAT $?

  echo "start ${COMPONENT} service"
  systemctl daemon-reload &>>$LOG_FILE
  systemctl enable ${COMPONENT} &>>$LOG_FILE
  systemctl restart ${COMPONENT} &>>$LOG_FILE
  STAT $?
}

STAT() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[1;32m Success\e[0m"
  else
    echo -e "\e[1;31m Failed\e[0m"
    exit 2
  fi
}