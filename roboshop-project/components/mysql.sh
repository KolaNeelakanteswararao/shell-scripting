source  components/common.sh

echo "Setup repo file"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG_FILE
STAT $?

echo "Install MySQL"
yum install mysql-community-server -y &>>$LOG_FILE
STAT $?

echo "Start MySQL"
systemctl enable mysqld &>>$LOG_FILE
systemctl start mysqld &>>$LOG_FILE
STAT $?

DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}') 
echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('Roboshop@1');
uninstall plugin validate_password;" >/tmp/pass.sql

echo "Change DEFAULT PASSWORD"
echo 'show databases' | mysql -uroot -pRoboshop@1 &>>$LOG_FILE
if [ $? -ne 0 ];then
  mysql --connect-expired-password -uroot -p"{$DEFAULT_PASSWORD}" </tmp/pass.sql &>>$LOG_FILE
fi
STAT $?

echo "Download mysql Shipping schema"
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>$LOG_FILE
STAT $?

echo "Extract shipping schema"
cd /tmp
unzip -o mysql.zip &>>$LOG_FILE
STAT $?

echo "Load Schema"
mysql -uroot -pRoboshop@1 <mysql-main/shipping.sql &>>$LOG_FILE
STAT $?