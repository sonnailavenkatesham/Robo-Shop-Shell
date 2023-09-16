#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
DATE=$(date +%f)
LOGDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGDIR/$SCRIPT_NAME-$DATE.log
USERID=$(id -u)
if [ $USERID -ne 0 ]
then 
    echo -e "$R ERROR: You are not Root User..$N"
    exit 1
fi
VALIDATE(){
if [ $1 -ne 0 ]
then  
    echo -e "$R $2..FAILED $N"
    exit 1
else    
    echo -e " $2..$G SUCCESS $N"
fi
}
yum install nginx -y &>>$LOGFILE
VALIDATE $? "install nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "enable nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "remove usr"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOGFILE
VALIDATE $? "start zipping"

cd /usr/share/nginx/html &>>$LOGFILE
VALIDATE $? "changing user"

unzip /tmp/web.zip &>>$LOGFILE
VALIDATE $? "web.zip"

cp /home/centos/Robo-Shop-Shell/roboshop.conf /etc/nginx/default.d/roboshop.conf  &>>$LOGFILE
VALIDATE $? "copying roboshop.conf"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "restart nginx"