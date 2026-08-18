# Deployment Guide

## End-to-End Automated & Secure n-Tier Cloud Infrastructure with Application Deployment

This document describes the deployment process for provisioning AWS infrastructure using Terraform and deploying the application through Jenkins CI/CD.

---

## 1. Prerequisites

Install and configure:

* AWS CLI
* Terraform
* Git

## 2. Local Setup

The project includes helper scripts for setting up the required tools on a Linux environment.

### Install Terraform 

```bash
chmod +x scripts/install-terraform.sh
./scripts/install-terraform.sh
```
Verify:

```bash
aws --version
terraform --version
git --version

```

Configure AWS:

```bash
aws configure
```

Verify AWS access:

```bash
aws sts get-caller-identity
```

---

## 2. Clone Repository

```bash
git clone https://github.com/arunmothe1/End-to-End-Automated-Secure-n-Tier-Cloud-Infrastructure-with-Application-Deployment.git
```

```bash
cd End-to-End-Automated-Secure-n-Tier-Cloud-Infrastructure-with-Application-Deployment
```

---

## 3. Terraform Deployment

Navigate to the Terraform directory:

```bash
cd terraform
```

Initialize Terraform:

```bash
terraform init
```

Format configuration:

```bash
terraform fmt -recursive
```

Validate configuration:

```bash
terraform validate
```

Create and review the execution plan:

```bash
terraform plan
```

Deploy the infrastructure:

```bash
terraform apply
```

Confirm:

```text
yes
```

---

## 4. AWS Infrastructure

Terraform provisions the required AWS infrastructure:

```text
VPC
│
├── Public Subnet
│   ├── Application Load Balancer
│   ├── Jenkins Server
│   └── NAT Gateway
│
├── Private Application Subnet
│   ├── Application Server 1
│   └── Application Server 2
│
└── Private Database Subnet
    └── Database Server
```

The network flow is:

```text
Internet
   │
   ▼
Internet Gateway
   │
   ▼
Application Load Balancer
   │
   ▼
Private Application Servers
   │
   ▼
Private Database Server
```

Private instances use the NAT Gateway for required outbound internet connectivity.

---

## 5. Terraform Outputs

After successful deployment:

```bash
terraform output
```

Check the required outputs such as:

```text
VPC ID
Load Balancer DNS
Jenkins Public IP
Application Instance IDs
```

---

## 6. Jenkins Configuration

Connect to the Jenkins server:

```bash
ssh -i <key>.pem ec2-user@<JENKINS_PUBLIC_IP>
```

Check Jenkins:

```bash
sudo systemctl status jenkins
```

Access Jenkins:

```text
http://<JENKINS_PUBLIC_IP>:8080
```

Configure the GitHub repository and required Jenkins credentials.

Credentials must be stored using the Jenkins Credentials Manager and must not be hard-coded in the pipeline.

---

## 7. CI/CD Pipeline

The Jenkins pipeline automates application deployment:

```text
GitHub
   │
   ▼
Jenkins
   │
   ├── Checkout
   ├── Build
   ├── Test
   ├── Docker Build
   ├── Docker Push
   └── Deploy
          │
          ▼
   Private Application EC2
```

---

## 8. Docker Deployment

Build the Docker image:

```bash
docker build -t application:latest .
```

Verify the image:

```bash
docker images
```

Run the container:

```bash
docker run -d --name application -p 80:80 application:latest
```

Verify:

```bash
docker ps
```

Check logs:

```bash
docker logs application
```

---

## 9. Application Verification

Get the Load Balancer DNS:

```bash
terraform output load_balancer_dns
```

Test the application:

```bash
curl http://<ALB-DNS>
```

Or open:

```text
http://<ALB-DNS>
```

Verify that the Application Load Balancer target group reports the application instances as **Healthy**.

---

## 10. Deployment Verification

Verify:

```text
✓ Terraform deployment successful
✓ VPC and networking available
✓ Jenkins server running
✓ Application instances running
✓ Docker container running
✓ ALB available
✓ Target instances healthy
✓ Application accessible through ALB
✓ Database accessible from application tier
```
## 10. Application Health Check

After the infrastructure and application deployment are complete, run the health-check script from the project root:

```bash
chmod +x scripts/health-check.sh
./scripts/health-check.sh
```

## 11. Infrastructure Cleanup

Review resources before destroying:

```bash
terraform plan -destroy
```

Destroy the Terraform-managed infrastructure when it is no longer required:

```bash
terraform destroy
```

Confirm:

```text
yes
```

---

## Deployment Flow

```text
Developer
    │
    ▼
GitHub
    │
    ▼
Jenkins CI/CD
    │
    ├── Build
    ├── Test
    ├── Docker Build
    └── Deploy
          │
          ▼
   Private Application EC2
          │
          ▼
     Application
          │
          ▼
      Database
```
