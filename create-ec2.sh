#!/bin/bash

NAME=("catalog" "mongodb" "user" "cart" "mysql" "rabbitmq" "redis" "web" "payment" "shipping")
for i in "${NAME[@]}"
do 
    echo " Name $num: $i "
    aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type t2.micro --security-group-ids sg-0f8c523d0f4ed489b
done