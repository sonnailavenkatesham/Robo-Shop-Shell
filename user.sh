#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
DATE=$(date +%F)
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
VALIDATE $? "Downloading user artifact"

yum list installed nodejs &>>$LOGFILE
if [ $? -ne 0 ]
then 
yum install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodeJS"
else
    echo -e "$Y nodejs Already Installed $N"
fi

id roboshop &>>$LOGFILE
if [ $? -ne 0 ]
then
    useradd roboshop &>>$LOGFILE
else    
    echo -e "$Y user roboshop is already exist $N"
fi

ls /app &>>$LOGFILE
if [ $? -ne 0 ]
then
    mkdir /app &>>$LOGFILE
    VALIDATE $? "created app directory"
else
    echo -e "$Y App directory already exist $N"
fi

curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>$LOGFILE

    cd /app &>>$LOGFILE
    VALIDATE $? "moving to app directory"

unzip /tmp/user.zip &>>$LOGFILE
VALIDATE $? "unziping user"

npm install &>>$LOGFILE
VALIDATE $? "Installing Dependies"

cp /home/centos/Robo-Shop-Shell/user.service /etc/systemd/system/user.service &>>$LOGFILE
VALIDATE $? "copying to user.service"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "daemon-reload"

systemctl enable user &>>$LOGFILE
VALIDATE $? "enable user "

systemctl start user &>>$LOGFILE
VALIDATE $? "start user"

cp /home/centos/Robo-Shop-Shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE
VALIDATE $? "copying to mongo.repo"

yum list installed mongodb-org-shell &>>$LOGFILE
if [ $? -ne 0 ]
then
    yum install mongodb-org-shell -y &>>$LOGFILE
    VALIDATE $? "install mongodb-org-shell"
else
    echo -e "$Y install mongodb-org-shell Already Installed $N" 
fi

mongo --host mongodb.venkateshamsonnalia143.online </app/schema/user.js &>>$LOGFILE
VALIDATE $? "hosted mongodb "