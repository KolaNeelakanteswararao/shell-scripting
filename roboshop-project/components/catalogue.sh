echo "Set up NodeJs Repo"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>>$LOG_FILE

echo "Installing NodeJs"
yum install nodejs -y &>>$LOG_FILE

echo "create app user"
useradd roboshop &>>LOG_FILE

echo "Download catalogue code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE

echo "Extract catalogue code"
cd /tmp/
unzip  -o /tmp/catalogue.zip &>>LOG_FILE

echo "clean catalogue old content"
rm -rf /home/roboshop/catalogue

echo "copy catalogue content"
cp -r catalogue-main /home/roboshop/catalogue &>>LOG_FILE

echo "install nodejs dependencies"
cd /home/roboshop/catalogue &>>LOG_FILE
npm install -y &>>LOG_FILE

chown roboshop:robosop /home/roboshop -R

echo "update systemD file"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service &>>LOG_FILE

echo "setup catalogue systemD file"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>LOG_FILE

echo "start catalogue service"
systemctl daemon-reload &>>LOG_FILE
systemctl enable catalogue &>>LOG_FILE
systemctl start catalogue &>>LOG_FILE