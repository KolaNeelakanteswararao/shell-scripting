source components/common.sh

echo "Installing Nginx"
yum install nginx -y &>>$LOG_FILE
STAT $?

echo "Download frontend content"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
STAT $?

echo "clean old content"
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
STAT $?

echo "Extract frontend content"
cd /tmp
unzip -o frontend.zip &>>$LOG_FILE
STAT $?

echo "copy extracted content to nginx path"
cp -r frontend-main/static/* /usr/share/nginx/html/ &>>$LOG_FILE
STAT $?

echo "copy nginx roboshop config"
cp frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
STAT $?

echo "Update Roboshop config"
sed -i -e "/catalogue/ s/localhost/catalogue.roboshop.internal/" -e "/user/ s/localhost/user.roboshop.internal/" /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
STAT $?

echo "start nginx service"
systemctl enable nginx &>>$LOG_FILE
systemctl restart nginx &>>$LOG_FILE
STAT $?