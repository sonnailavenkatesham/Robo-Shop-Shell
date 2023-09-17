#!/bin/bash

NAME=("catalog" "mongodb" "user" "cart" "mysql" "rabbitmq" "redis" "web" "payment" "shipping")
num=1
for i in "${NAME[@]}"
do 
    echo " Name $num: $i "
    $num=num+1
done