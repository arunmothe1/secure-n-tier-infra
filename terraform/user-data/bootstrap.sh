#!/bin/bash
set -e

# System updates
dnf update -y

# Install Docker, Java 17 & Git (Jenkins Requirements)
dnf install -y docker java-17-amazon-corretto-devel git

# Enable and start Docker service
systemctl enable --now docker
usermod -aG docker ec2-user

# Add Jenkins repository & GPG Key
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install and start Jenkins
dnf install -y jenkins
systemctl enable --now jenkins

# Ensure Jenkins user has Docker permissions for CI/CD builds
usermod -aG docker jenkins