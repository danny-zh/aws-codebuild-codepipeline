#!/bin/bash
echo "Downloading and installing docker"
sudo yum update 
sudo yum install -y docker

echo "Getting parameters from SSM"
AWS_DEFAULT_REGION=$(aws ssm get-parameter --name DEFAULT_REGION --query "Parameter.Value"  | sed 's/\"//g')
AWS_ACCOUNT_ID=$(aws ssm get-parameter --name ACCOUNT_ID --query "Parameter.Value" | sed 's/\"//g')
IMAGE_REPO_NAME=$(aws ssm get-parameter --name IMAGE_REPO_NAME --query "Parameter.Value" | sed 's/\"//g')
IMAGE_TAG=$(aws ssm get-parameter --name IMAGE_TAG --query "Parameter.Value" | sed 's/\"//g')

echo "Logging into AWS ECR"
aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
echo "Pulling image from AWS ECR"
sudo docker pull $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG
sudo docker tag $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG $IMAGE_REPO_NAME:$IMAGE_TAG