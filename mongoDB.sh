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

cp /home/centos/Robo-Shop-Shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE
VALIDATE $? "copying mongo.repo file"

yum list installed mongodb-org &>>$LOGFILE
if [ $? -ne 0 ]
then
    yum install mongodb-org -y &>>$LOGFILE
    VALIDATE $? "Installing mongodb-org"
else
    echo -e "$Y mongodb-org Already Installed..$N"  
fi

systemctl enable mongod &>>$LOGFILE
VALIDATE $? "enable mongod"

systemctl start mongod &>>$LOGFILE
VALIDATE $? "start mongod"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOGFILE
VALIDATE $? "edited mongod config"

systemctl restart mongod &>>$LOGFILE
VALIDATE $? "restart mongod"
