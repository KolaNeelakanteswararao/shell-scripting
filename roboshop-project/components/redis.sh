source components/common.sh

echo "Create Redis repo file"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>$LOG_FILE
STAT $?

echo "Installing Redis"
yum install redis-6.2.7 -y &>>$LOG_FILE
STAT $?

echo "Update Redis configuration"
if [ -f /etc/redis.conf ]; then
  sed -i -e "s/127.0.0.1/0.0.0.0/g /etc/redis.conf" &>>$LOG_FILE
elif [ -f /etc/redis/redis.conf ]; then
  sed -i -e "s/127.0.0.1/0.0.0.0/g /etc/redis/redis.conf" &>>$LOG_FILE
  exit
fi
STAT $?

echo "Start Redis service"
systemctl enable redis &>>$LOG_FILE
systemctl start redis &>>LOG_FILE
STAT $?