source components/commen.sh

echo "Installing Nginx"
yum install nginx -y &>>LOG_FILE

echo "Download frontend content"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>LOG_FILE

echo "clean old content"
rm -rf /usr/share/nginx/html/* &>>LOG_FILE

echo "Extract frontend content"
cd /tmp
unzip -o frontend.zip &>>LOG_FILE

echo "copy extracted content to nginx path"
cp -r frontend-main/static/* /usr/share/nginx/html/ &>>LOG_FILE

echo "copy nginx roboshop config"
cp frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>LOG_FILE

echo "start nginx service"
systemctl enable nginx &>>LOG_FILE
systemctl start nginx &>>LOG_FILE