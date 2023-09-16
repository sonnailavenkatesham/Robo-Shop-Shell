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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash

yum install nodejs -y

useradd roboshop

mkdir /app

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip

cd /app 

unzip /tmp/user.zip

cd /app 

npm install 

cp /home/centos/Robo-Shop-Shell/user.service /etc/systemd/system/user.service

systemctl daemon-reload

systemctl enable user 

systemctl start user

cp /home/centos/Robo-Shop-Shell/mongo.repo /etc/yum.repos.d/mongo.repo

yum install mongodb-org-shell -y

mongo --host mongodb.venkateshamsonnalia143.online </app/schema/user.js