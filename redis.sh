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

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
VALIDATE $? "rpms.remirepo.net"

yum module enable redis:remi-6.2 -y
VALIDATE $? "enable redis:remi-6.2"

yum install redis -y 
VALIDATE $? "install redis"

sed -i 's/127.0.0.1/0.0.0./' /etc/redis.conf
VALIDATE $? "redis edited congig"

systemctl enable redis
VALIDATE $? "enable redis"

systemctl start redis
VALIDATE $? "start redis"