#!/bin/bash

NAME=("catalog" "mongodb" "user" "cart" "mysql" "rabbitmq" "redis" "web" "payment" "shipping")
for i in "${NAME[@]}"
do 
    echo " Name $num: $i "
done