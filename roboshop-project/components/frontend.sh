LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

echo "Installing Nginx"
yum install nginx -y &>>LOG_FILE

echo "Download Frontend Content"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>LOG_FILE

echo "Clean old content"
rm -rf /usr/share/nginx/html/* &>>LOG_FILE

echo "Extract frontend content"
cd /tmp
unzip -o frontend.zip &>>LOG_FILE

echo "copy extract content to Nginx path"
cp -r frontend-main/static/* /usr/share/nginx/html/ &>>LOG_FILE

echo "copy Nginx roboshop config"
cp frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>LOG_FILE

echo "start nginx service"
systemctl enable nginx
systemctl start nginx