#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
PACKEGE=$(yum list installed)
USERID=$(id -u)
if [ $USERID -ne 0 ]
then 
    echo -e "$R ERROR: You are not Root User..$N"
    exit 1
fi
VALIDATE(){
if [ $1 -ne 0 ]
then  
    echo -e "$R Installation..$2..FAILED $N"
    exit 1
else    
    echo -e "$G Installation..$2..SUCCESS $N"
fi
}

if [ $1 -ne 0 ]
then
yum install git -y
VALIDATE $? "git"
else
    echo "Already installed git"
fi