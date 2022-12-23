source components/common.sh

echo "set up mongodb repo file"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
STAT $?

echo "Installing Mongodb"
yum install mongodb-org -y &>>$LOG_FILE
STAT $?

echo "updating config file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG_FILE
STAT $?

echo "start the mongodb service"
systemctl enable mongod &>>$LOG_FILE
systemctl start mongod &>>$LOG_FILE
STAT $?

echo "download the schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
STAT $?

echo "Extract mongodb content"
cd /tmp/
unzip -o mongodb.zip &>>$LOG_FILE
STAT $?

echo "to load other component service"
cd mongodb-main
mongo < catalogue.js &>>$LOG_FILE
mongo < users.js &>>$LOG_FILE
STAT $?