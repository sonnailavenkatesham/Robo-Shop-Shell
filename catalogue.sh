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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE
VALIDATE $? "Downloading catalogue artifact"

yum install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodeJS"

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE

cd /app &>>$LOGFILE

unzip /tmp/catalogue.zip &>>$LOGFILE
VALIDATE $? "unziping catalogue"

cd /app &>>$LOGFILE
VALIDATE $? "moving to app deirectory"

npm install &>>$LOGFILE
VALIDATE $? "Installing Dependies"

cp /home/centos/Robo-Shop-Shell/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE
VALIDATE $? "copying to catalogue.service"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "daemon-reload"

systemctl enable catalogue &>>$LOGFILE
VALIDATE $? "enable catalogue "

systemctl start catalogue &>>$LOGFILE
VALIDATE $? "start catalogue"

cp /home/centos/Robo-Shop-Shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE
VALIDATE $? "copying to mongo.repo"

yum install mongodb-org-shell -y &>>$LOGFILE
VALIDATE $? "install mongodb-org-shell"

mongo --host mongodb.venkateshsamsonnalia143.online </app/schema/catalogue.js &>>$LOGFILE
VALIDATE $? "hosted mongodb "