#!/bin/bash

dnf update -y

dnf install -y \
  git \
  docker \
  awscli \
  java-17-amazon-corretto \
  amazon-ssm-agent

systemctl enable docker
systemctl start docker

systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

curl -fsSL https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key \
  -o /etc/pki/rpm-gpg/jenkins-keyring.asc

cat > /etc/yum.repos.d/jenkins.repo <<EOF
[jenkins]
name=Jenkins
baseurl=https://pkg.jenkins.io/redhat-stable/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/jenkins-keyring.asc
enabled=1
EOF

dnf install -y jenkins

usermod -aG docker jenkins

systemctl enable jenkins
systemctl start jenkins

curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \
  | sh -s -- -b /usr/local/bin