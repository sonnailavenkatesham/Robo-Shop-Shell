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

ALL_COMMANDS=("curl -sL https://rpm.nodesource.com/setup_lts.x | bash" "yum install nodejs -y" "useradd roboshop" "mkdir /app" "curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip" "cd /app " "unzip /tmp/catalogue.zip" "cd /app" "npm install " "cp /home/centos/Robo-Shop-Shell/catalogue.service /etc/systemd/system/catalogue.service" "systemctl daemon-reload" "systemctl enable catalogue" "systemctl start catalogue" "cp /home/centos/Robo-Shop-Shell/mongo.repo /etc/yum.repos.d/mongo.repo" "yum install mongodb-org-shell -y" "mongo --host mongodb.venkateshamsonnalia143.online </app/schema/catalogue.js" )

for command in "${ALL_COMMANDS[@]}"
 do
    $command
done
