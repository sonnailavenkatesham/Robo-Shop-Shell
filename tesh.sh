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

for command in (("curl -sL https://rpm.nodesource.com/setup_lts.x | bash" "yum install nodejs -y")) &>>$LOGFILE
 do
    if [ $? -ne 0 ]
    then
        $command
        VALIDATE $@ "$command"
    else 
        echo -e "$Y $i Already done.. $N"
    fi 
done
