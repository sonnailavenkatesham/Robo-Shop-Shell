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
VALIDATE $? "Downloading cart artifact"

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

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$LOGFILE
VALIDATE $? "Roboshop zip"

cd /app &>>$LOGFILE
VALIDATE $? "moving to app directory"


unzip /tmp/cart.zip &>>$LOGFILE
VALIDATE $? "unziping cart"

npm install &>>$LOGFILE
VALIDATE $? "Installing Dependies"

cp /home/centos/Robo-Shop-Shell/cart.service /etc/systemd/system/cart.service &>>$LOGFILE
VALIDATE $? "copying to cart.service"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "daemon-reload"

systemctl enable cart &>>$LOGFILE
VALIDATE $? "enable cart "

systemctl start cart &>>$LOGFILE
VALIDATE $? "start cart"