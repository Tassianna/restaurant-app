#!/bin/bash
source .env

echo "project initializing in Graces machine"

echo "sign into desired AWS"

aws configure set aws_access_key_id ${AWS_ACCESS_KEY} && \
aws configure set aws_secret_access_key ${AWS_ACCESS_SECRET_KEY} && \
aws configure set region ${AWS_REGION}
