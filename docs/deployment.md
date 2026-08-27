# Deployment Guide

## End-to-End Automated & Secure n-Tier Cloud Infrastructure with Application Deployment

This document describes the deployment process for provisioning AWS infrastructure using Terraform and deploying the application through Jenkins CI/CD.

---

##  Prerequisites

### Complete Deployment Guide

## 1. Install Required Tools

Use a Linux machine or EC2 instance as the deployment/administration machine.

Check the required tools:

```bash
aws --version
terraform --version
git --version
```

If Terraform is not installed, use the project installation script:

```bash
chmod +x scripts/install-terraform.sh
./scripts/install-terraform.sh
```

Configure AWS CLI:

```bash
aws configure
```

Enter:

```text
AWS Access Key ID
AWS Secret Access Key
Default region: ap-south-1
Output format: json
```

Verify AWS access:

```bash
aws sts get-caller-identity
```

---

# 2. Clone GitHub Repository

Clone the project repository:

```bash
git clone https://github.com/arunmothe1/secure-n-tier-infra.git
```

Move into the project directory:

```bash
cd secure-n-tier-infra
```

Move to the Terraform directory:

```bash
cd terraform
```

---

# 3. Configure Terraform Variables

Create the Terraform variables file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Open the file:

```bash
nano terraform.tfvars
```

Configure the required values.

Example:

```hcl
key_name = "your-key-pair-name"
```

Save the file.

Verify the configuration:

```bash
cat terraform.tfvars
```

---

# 4. Initialize Terraform

Initialize the Terraform working directory:

```bash
terraform init
```

This downloads the required Terraform providers and initializes the project.

---

# 5. Format Terraform Configuration

Format all Terraform files:

```bash
terraform fmt -recursive
```

---

# 6. Validate Terraform Configuration

Validate the Terraform configuration:

```bash
terraform validate
```

Expected:

```text
Success! The configuration is valid.
```

---

# 7. Review Terraform Plan

Review the resources that Terraform will create:

```bash
terraform plan
```

Verify the planned AWS infrastructure before applying it.

---

# 8. Create AWS Infrastructure

Create the infrastructure:

```bash
terraform apply
```

Terraform will ask for confirmation.

Enter:

```text
yes
```

Terraform will provision the AWS infrastructure.

---

# 9. Verify Terraform Outputs

After Terraform completes:

```bash
terraform output
```

Check the important outputs such as:

```text
VPC ID
ALB DNS
Jenkins Public IP
Application Server Instance IDs
MongoDB Instance ID / Private IP
```

---

# 10. Verify AWS Infrastructure

Open:

**AWS Console → VPC / EC2**

Verify the following resources:

```text
VPC
Public Subnet
Private Application Subnet
Private Database Subnet
Internet Gateway
NAT Gateway
Elastic IP
Route Tables
Security Groups
Application Load Balancer
Target Group
EC2 Instances
```

Architecture:

```text
AWS VPC
│
├── Public Subnet
│   ├── Application Load Balancer
│   ├── Jenkins EC2
│   └── NAT Gateway
│
├── Private Application Subnet
│   ├── App Server 1
│   └── App Server 2
│
└── Private Database Subnet
    └── MongoDB EC2
```

---

## 11. Get Jenkins Public IP

Go to:

**AWS Console → EC2 → Instances**

Select the **Jenkins Server** instance.

Copy the **Public IPv4 address**.

Example:

```text
13.xx.xx.xx

```
---


## 12. Connect to Jenkins Server

From the administration/local machine, connect to Jenkins:

```bash
ssh -i your-key.pem ec2-user@YOUR_JENKINS_PUBLIC_IP
```

After login, confirm the hostname:

```bash
hostname
```

---

## 13. Verify Jenkins Server Tools

On the Jenkins Server, check Jenkins:

```bash
sudo systemctl status jenkins
```

Check Docker:

```bash
sudo systemctl status docker
```

Check Git:

```bash
git --version
```

Check Docker:

```bash
docker --version
```

Check Docker Compose:

```bash
docker compose version
```

If Jenkins does not have Docker permission:

```bash
sudo usermod -aG docker jenkins
```

Restart Jenkins:

```bash
sudo systemctl restart jenkins
```

---

# Jenkins UI Configuration

## 14. Open Jenkins UI

Open a browser and enter:

```text
http://YOUR_JENKINS_PUBLIC_IP:8080
```

Example:

```text
http://13.xx.xx.xx:8080
```

---

## 15. Get Initial Jenkins Password

On the Jenkins Server:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Copy the generated password.

In Jenkins:

```text
Unlock Jenkins
      ↓
Paste Administrator Password
      ↓
Continue
```

---

## 16. Install Jenkins Plugins

Select:

```text
Install suggested plugins
```

Wait until the plugin installation is complete.

---

## 17. Create Jenkins Admin User

Create the first Jenkins administrator account:

```text
Username: admin
Password: ********
Full Name: Your Name
Email: your-email@example.com
```

Then select:

```text
Save and Continue
      ↓
Start using Jenkins
```

---

# Jenkins Pipeline Configuration

## 18. Create Jenkins Pipeline Job

From Jenkins Dashboard:

```text
New Item
```

Enter:

```text
secure-n-tier-pipeline
```

Select:

```text
Pipeline
```

Click:

```text
OK
```

---

## 19. Configure Pipeline from GitHub

Go to:

```text
Pipeline
```

Set:

```text
Definition:
Pipeline script from SCM
```

SCM:

```text
Git
```

Repository URL:

```text
https://github.com/arunmothe1/secure-n-tier-infra.git
```

Branch:

```text
*/main
```

Script Path:

```text
Jenkins/Jenkinsfile
```

Click:

```text
Save
```

---

# Jenkins CI/CD Pipeline

## 20. Run First Jenkins Build

Open:

```text
secure-n-tier-pipeline
```

Click:

```text
Build Now
```

A new build will be created.

Example:

```text
Build #1
```

---

## 21. Check Console Output

Open:

```text
Build #1
    ↓
Console Output
```

The pipeline should execute the following stages:

```text
Docker Build
      ↓
Security Scan
      ↓
ECR Login
      ↓
Push Image to ECR
      ↓
Deploy to App Servers
```

At the end, verify:

```text
Finished: SUCCESS
```

---

## 22. Docker Image Build

Jenkins builds the application Docker image using the project Dockerfile.

The image is tagged using:

```text
BUILD_NUMBER
latest
```

Verify the generated image on the Jenkins Server:

```bash
docker images
```

---

## 23. Security Scan with Trivy

The Docker image is scanned using Trivy.

The scan checks for:

```text
HIGH
CRITICAL
```

severity vulnerabilities.

Verify Trivy:

```bash
trivy --version
```

---

## 24. Login to Amazon ECR

Jenkins uses AWS CLI to authenticate with Amazon ECR.

The flow is:

```text
Jenkins
   ↓
AWS CLI
   ↓
Amazon ECR Login
```

The ECR authentication is performed using:

```bash
aws ecr get-login-password
```

---

## 25. Push Docker Image to ECR

The Docker image is pushed to Amazon ECR.

Flow:

```text
Docker Image
      ↓
Amazon ECR
      ↓
BUILD_NUMBER / latest
```

Verify the repository from:

**AWS Console → ECR → Repositories**

---

# Dynamic MongoDB Configuration

## 26. Get MongoDB Private IP Dynamically

The Jenkins pipeline identifies the running MongoDB EC2 instance using its Name tag:

```text
secure-n-tier-infra-dev-mongodb
```

To manually verify the current private IP from the Jenkins Server:

```bash
aws ec2 describe-instances \
  --region ap-south-1 \
  --filters \
  "Name=tag:Name,Values=secure-n-tier-infra-dev-mongodb" \
  "Name=instance-state-name,Values=running" \
  --query 'Reservations[].Instances[].PrivateIpAddress' \
  --output text
```

Example output:

```text
10.0.22.32
```

---

## 27. Create MongoDB Connection URI

The Jenkins pipeline creates the MongoDB connection URI dynamically using the current private IP.

Example:

```text
mongodb://10.0.22.32:27017/crud
```

This avoids hard-coding the MongoDB IP address.

If the MongoDB EC2 instance is replaced and receives a new private IP, the pipeline can retrieve the new IP dynamically.

---

# Application Server Deployment

## 28. Deploy Application Using AWS Systems Manager

Jenkins uses AWS Systems Manager (SSM) to execute deployment commands on the private application servers.

Flow:

```text
Jenkins
    ↓
AWS Systems Manager
    ↓
Private App Server 1
Private App Server 2
```

The application deployment process is:

```text
ECR Login
    ↓
Docker Pull
    ↓
Remove Existing Container
    ↓
Start New Container
```

The application container runs on the application servers.

---

## 29. Verify Jenkins Pipeline

After deployment, check the Jenkins Console Output.

Verify:

```text
Docker Build       → SUCCESS
Security Scan      → SUCCESS
ECR Login          → SUCCESS
ECR Push           → SUCCESS
Deployment         → SUCCESS
```

Finally:

```text
Finished: SUCCESS
```

---

# Application Verification

## 30. Get ALB DNS

From the Terraform directory:

```bash
terraform output
```

Find the Application Load Balancer DNS name.

---

## 31. Open Application Through ALB

Open the ALB DNS in a browser:

```text
http://<ALB-DNS>
```

Example:

```text
http://secure-n-tier-alb-xxxxxxxx.ap-south-1.elb.amazonaws.com
```

---

## 32. Verify ALB Target Group

Open:

```text
AWS Console
   ↓
EC2
   ↓
Target Groups
   ↓
Your Target Group
   ↓
Targets
```

Verify:

```text
App Server 1 → Healthy
App Server 2 → Healthy
```

Both application servers should be in:

```text
Healthy
```

state.

---

## 33. Test Frontend

Open the ALB URL.

Verify that the:

```text
React / Vite Frontend
```

loads successfully.

Check the application UI and navigation.

---

## 34. Test Backend API

Open browser Developer Tools:

```text
F12
   ↓
Network
```

Perform application operations and verify the backend API requests.

Examples:

```text
GET  /api/users
POST /api/addUser
```

Verify that the API requests receive successful responses.

---

## 35. Run Application Health Check

Move to the project root directory:

```bash
cd ..
```

Make the health-check script executable:

```bash
chmod +x scripts/health-check.sh
```

Run:

```bash
./scripts/health-check.sh
```

Verify that the application health check completes successfully.

---

# GitHub Webhook / Automatic CI/CD

## 36. Configure GitHub Webhook Trigger in Jenkins

Open:

```text
Jenkins
   ↓
secure-n-tier-pipeline
   ↓
Configure
   ↓
Build Triggers
```

Enable:

```text
☑ GitHub hook trigger for GITScm polling
```

Click:

```text
Save
```

---

## 37. Add Webhook in GitHub

Open:

```text
GitHub Repository
   ↓
Settings
   ↓
Webhooks
   ↓
Add webhook
```

Payload URL:

```text
http://YOUR_JENKINS_PUBLIC_IP:8080/github-webhook/
```

Content type:

```text
application/json
```

Select:

```text
Just the push event
```

Enable:

```text
Active
```

Click:

```text
Add webhook
```

---

## 38. Test GitHub Webhook

Make a small change in the project.

Then:

```bash
git add .
```

```bash
git commit -m "test github webhook"
```

```bash
git push origin main
```

The expected flow is:

```text
Developer
    ↓
git push
    ↓
GitHub
    ↓
Webhook
    ↓
Jenkins
```

---

## 39. Verify Automatic Jenkins Build

Open Jenkins and check **Build History**.

A new build should start automatically.

Example:

```text
Build #2
```

Open:

```text
Build #2
   ↓
Console Output
```

Verify:

```text
Docker Build
      ↓
Security Scan
      ↓
ECR Login
      ↓
Push to ECR
      ↓
Deploy to App Servers
      ↓
Finished: SUCCESS
```

---

# 40. Final Project Verification

Verify the complete infrastructure and CI/CD workflow:

```text
✓ AWS VPC Created
✓ Public Subnet Created
✓ Private Application Subnet Created
✓ Private Database Subnet Created
✓ Internet Gateway Configured
✓ NAT Gateway Configured
✓ Elastic IP Configured
✓ Route Tables Configured
✓ Security Groups Configured
✓ Application Load Balancer Configured
✓ Target Group Configured
✓ Jenkins EC2 Configured
✓ App Server 1 Configured
✓ App Server 2 Configured
✓ MongoDB EC2 Configured
✓ Jenkins Pipeline Configured
✓ Docker Image Built
✓ Trivy Security Scan Completed
✓ Amazon ECR Image Push Completed
✓ MongoDB Private IP Retrieved Dynamically
✓ AWS Systems Manager Deployment Completed
✓ Application Servers Updated
✓ ALB Targets Healthy
✓ Frontend Tested
✓ Backend API Tested
✓ Health Check Completed
✓ GitHub Webhook Configured
✓ Automatic Jenkins Build Tested
✓ CI/CD Pipeline Completed Successfully
```

# Final Architecture

```text
                              INTERNET
                                  │
                                  ▼
                         ┌─────────────────┐
                         │       ALB       │
                         │  Public Subnet  │
                         └────────┬────────┘
                                  │
                           Application Traffic
                                  │
                    ┌─────────────┴─────────────┐
                    ▼                           ▼
             ┌─────────────┐             ┌─────────────┐
             │ App Server 1│             │ App Server 2│
             │   Private   │             │   Private   │
             │   Docker    │             │   Docker    │
             └──────┬──────┘             └──────┬──────┘
                    │                           │
                    └─────────────┬─────────────┘
                                  │
                                  ▼
                         ┌────────────────┐
                         │    MongoDB     │
                         │ Private DB     │
                         └────────────────┘


Developer
    │
    │ git push
    ▼
 GitHub
    │
    │ Webhook
    ▼
 Jenkins
    │
    ├── Docker Build
    ├── Trivy Security Scan
    ├── ECR Login
    ├── Push Image to ECR
    └── SSM Deployment
             │
             ▼
      Private App Servers
```

# Project Completion

```text
GitHub
   ↓
Jenkins
   ↓
Docker Build
   ↓
Trivy Security Scan
   ↓
Amazon ECR
   ↓
AWS Systems Manager
   ↓
Private App Servers
   ↓
Application Load Balancer
   ↓
Application
```

**CI/CD Pipeline Completed Successfully.**
