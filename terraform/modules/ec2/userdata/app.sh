#!/bin/bash

dnf update -y

dnf install -y \
  docker \
  awscli \
  amazon-ssm-agent

systemctl enable docker
systemctl start docker

systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

usermod -aG docker ec2-user

aws ecr get-login-password --region ${aws_region} | \
docker login \
  --username AWS \
  --password-stdin ${ecr_repository_url}

until docker pull ${ecr_repository_url}:latest
do
  sleep 30
done

docker rm -f app 2>/dev/null || true

docker run -d \
  --name app \
  --restart unless-stopped \
  -p 3000:3000 \
  -e MONGO_URI="mongodb://${mongodb_private_ip}:27017/crud" \
  ${ecr_repository_url}:latest