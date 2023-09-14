#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
USERID=$(id -u)
if [ $USERID -ne 0 ]
then 
    echo -e "$R ERROR: You are not Root User..$N"
    exit 1
fi
yum install git -y