#!/bin/bash

INSTANCE_NAME=$1

if [ -z "$INSTANCE_NAME" ]; then
  echo "\e[1;33mInstance Name Arguement is needed\e[0m"
  exit
fi

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" --query 'Images[*].[ImageId]' --output text)

if [ -z "${AMI_ID}" ];then
   echo -e "\e[1;31mUnable to find image  AMI_ID\e[0m"
   exit
else
  echo -e "\e[1;32mAMI_ID=${AMI_ID}\e[0m"
fi

PRIVATE_IP=$(aws ec2 describe-instances --filters Name=tag:Name,Values=${INSTANCE_NAME} --query 'Reservations[*].Instance[*] PrivateIpAddress' --output text)

if [ -z "${PRIVATE_IP}" ]; then
aws ec2 run-instances --image-id ${AMI_ID} --instance-type t2.micro --output text --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${INSTANCE_NAME}}]"
else
  echo "Instance ${INSTANCE_NAME} is already exits,Hence not creating"
  exit
fi
