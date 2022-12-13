source components/common.sh

echo "setup mongodb repo file"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>LOG_FILE

echo "Installing mongodb"
yum install mongodb-org -y &>>LOG_FILE

echo "Update config file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>LOG_FILE

echo "start database"
systemctl enable mongod &>>LOG_FILE
systemctl start mongod &>>LOG_FILE

echo "Download schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>LOG_FILE

echo "Extract schema"
cd /tmp/
unzip -o mongod.zip &>>LOG_FILE

echo "load schema"
cd mongodb-main &>>LOG_FILE
mongo < catalogue.js &>>LOG_FILE
mongo < users.js &>>LOG_FILE