#!/bin/bash
IMAGE_ID=ami-03265a0778a880afb
INSTANCE_TYPE=t2.micro
SECURITY_GROUP=sg-0f8c523d0f4ed489b
HOTSTED_ZONE=Z0997824248HW2XYA9N5U
DOMAIN_NAME=venkateshamsonnalia143.online
NAME=("catalog" "mongodb" "user" "cart" "mysql" "rabbitmq" "redis" "web" "payment" "shipping")
for i in "${NAME[@]}"
do 
    echo " Name $num: $i "
    IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')

    aws route53 change-resource-record-sets --hosted-zone-id Z0997824248HW2XYA9N5U --change-batch '
    {
            "Changes": [{
            "Action": "CREATE",
                        "ResourceRecordSet": {
                                "Name": "'$i.venkateshamsonnalia143.online'",
                                "Type": "A",
                                "TTL": 300,
                                "ResourceRecords": [{"'Value": "$IP_ADDRESS'"}]
                        }}]
    }
    '
done