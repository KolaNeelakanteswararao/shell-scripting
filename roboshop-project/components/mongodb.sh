source components/common.sh

echo "set up mangodb repo file"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE

echo "Installing Mangodb"
yum install mangodb-org -y &>>$LOG_FILE

echo "updating config file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG_FILE

echo "start the mangodb service"
systemctl enable mangod &>>$LOG_FILE
systemctl start mangod &>>$LOG_FILE

echo "download the schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE

echo "Extract mongodb content"
cd /tmp/
unzip -o mongodb.zip &>>$LOG_FILE

echo "to load other component service"
cd mongodb-main
mongo < catalogue.js &>>$LOG_FILE
mongo < users.js &>>$LOG_FILE