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

yum install maven -y
VALIDATE $? "Installing maven"

useradd roboshop
VALIDATE $? "useradded roboshop"

mkdir /app
VALIDATE $? "creating app directory"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip
VALIDATE $? "shipping ARTIFACT "

cd /app
VALIDATE $? "moving to app directory"

unzip /tmp/shipping.zip
VALIDATE $? "/tmp/shipping.zip"

mvn clean package
VALIDATE $? "clean packagecreating app directory"

mv target/shipping-1.0.jar shipping.jar
VALIDATE $? "setting taget for shipping"

cp /home/centos/Robo-Shop-Shell/shipping.service /etc/systemd/system/shipping.
VALIDATE $? "copying shipping services"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "daemon-reload"

systemctl enable shipping &>>$LOGFILE
VALIDATE $? "enable shipping "

systemctl start shipping &>>$LOGFILE
VALIDATE $? "start shipping"

yum install mysql -y
VALIDATE $? "Installing mysql" 

mysql -h mysql.venkateshamsonnalia143.online -uroot -pRoboShop@1 < /app/schema/shipping.sql 
VALIDATE $? "hosting shipping"

systemctl restart shipping
VALIDATE $? "restart shipping"