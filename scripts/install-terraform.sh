#!/bin/bash
# Helper script to install Terraform CLI on Linux environments

set -e

echo "Starting Terraform installation..."

if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        amzn|rhel|centos|fedora)
            echo "Detected RHEL-based system ($ID)..."
            sudo yum install -y yum-utils
            sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
            sudo yum install -y terraform
            ;;
        ubuntu|debian)
            echo "Detected Debian-based system ($ID)..."
            sudo apt-get update -y
            sudo apt-get install -y wget gnupg lsb-release
            
            wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg --overwrite
            echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
            
            sudo apt-get update -y
            sudo apt-get install -y terraform
            ;;
        *)
            echo "Unsupported OS: $ID. Please install Terraform manually."
            exit 1
            ;;
    esac
else
    echo "Cannot determine OS (/etc/os-release not found)."
    exit 1
fi

echo "Terraform installed successfully!"
terraform -v