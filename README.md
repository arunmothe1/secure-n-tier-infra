# End-to-End Automated & Secure n-Tier Cloud Infrastructure with Application Deployment

A secure, scalable, and automated **n-Tier application infrastructure** deployed on AWS using **Terraform, Docker, Jenkins, GitHub, Amazon ECR, Trivy, AWS Systems Manager, and MongoDB**.

This project demonstrates Infrastructure as Code, secure network segmentation, containerization, CI/CD automation, container vulnerability scanning, dynamic database configuration, and automated application deployment on AWS.

---

## Project Overview

The infrastructure is deployed inside an **AWS VPC** with three dedicated network tiers:

```text
AWS VPC
│
├── Public Subnet
│   ├── Application Load Balancer (ALB)
│   └── Jenkins Server
│
├── Private Application Subnet
│   ├── App Server 1
│   └── App Server 2
│
└── Private Database Subnet
    └── MongoDB Server
```

The application servers run Docker containers in private subnets, while MongoDB is isolated in a dedicated private database subnet.

The Application Load Balancer is the public entry point for application traffic. Jenkins automates the build, security scanning, image publishing, and deployment process.

---

## Architecture

```text
                              INTERNET
                                  │
                                  ▼
                         ┌─────────────────┐
                         │      ALB        │
                         │  Public Subnet  │
                         └────────┬────────┘
                                  │
                         Application Traffic
                                  │
                    ┌─────────────┴─────────────┐
                    ▼                           ▼
             ┌─────────────┐             ┌─────────────┐
             │ App Server 1│             │ App Server 2│
             │    EC2      │             │    EC2      │
             │   Docker    │             │   Docker    │
             └──────┬──────┘             └──────┬──────┘
                    │                           │
                    └─────────────┬─────────────┘
                                  │
                           Database Traffic
                                  │
                                  ▼
                         ┌────────────────┐
                         │    MongoDB     │
                         │      EC2       │
                         │  Private DB    │
                         └────────────────┘
```

---

## CI/CD Architecture

```text
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
    ├── Checkout Source Code
    │
    ├── Build Docker Image
    │
    ├── Scan Image with Trivy
    │
    ├── Authenticate with Amazon ECR
    │
    ├── Push Image to ECR
    │
    ├── Discover MongoDB Private IP
    │
    └── Deploy through AWS Systems Manager
             │
             ▼
      Private App Servers
             │
             ▼
         Application
```

---

## Application Traffic Flow

Application traffic flows through the Application Load Balancer.

```text
Internet
   ↓
Application Load Balancer
   ↓
Target Group
   ↓
App Server 1 / App Server 2
   ↓
MongoDB
```

The ALB distributes incoming requests across the private application servers registered in the target group.

---

## Deployment Traffic Flow

Deployment traffic is handled independently from application traffic.

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
```

---

## Technology Stack

| Category                | Technologies                              |
| ----------------------- | ----------------------------------------- |
| Cloud                   | AWS                                       |
| Infrastructure as Code  | Terraform                                 |
| Compute                 | Amazon EC2                                |
| Networking              | VPC, Subnets, Route Tables                |
| Connectivity            | Internet Gateway, NAT Gateway, Elastic IP |
| Load Balancing          | Application Load Balancer, Target Groups  |
| Security                | IAM, Security Groups, Trivy               |
| Containers              | Docker, Docker Compose                    |
| Container Registry      | Amazon ECR                                |
| CI/CD                   | Jenkins                                   |
| Version Control         | Git, GitHub                               |
| Server Operating System | Amazon Linux 2023                         |
| Server Management       | AWS Systems Manager, Session Manager      |
| Web Server              | Nginx                                     |
| Frontend                | React, Vite                               |
| Backend                 | Node.js, Express.js                       |
| Database                | MongoDB                                   |
| Scripting               | Bash, Linux                               |
| Server Access           | SSH                                       |
| Command-Line Tools      | AWS CLI                                   |

---

## Project Structure

```text
secure-n-tier-infra/
│
├── application/
│   ├── client/
│   └── server/
│
├── Docker/
│   ├── .dockerignore
│   ├── docker-compose.yml
│   ├── Dockerfile
│   ├── nginx.conf
│   └── supervisord.conf
│
├── docs/
│   ├── deployment.md
│   └── security.md
│
├── Jenkins/
│   └── Jenkinsfile
│
├── scripts/
│   ├── Health-check.sh
│   └── install-terraform.sh
│
├── terraform/
│   ├── modules/
│   │   ├── alb/
│   │   ├── ec2/
│   │   ├── ecr/
│   │   ├── security-group/
│   │   └── vpc/
│   │
│   ├── screenshots/
│   ├── data.tf
│   ├── locals.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── README.md
│   ├── terraform.tfvars
│   ├── terraform.tfvars.example
│   ├── variables.tf
│   └── versions.tf
│
├── .gitignore
└── README.md
```

> Terraform state files, the `.terraform` directory, credentials, private keys, and other sensitive files should not be committed to the Git repository.

---


---

## Infrastructure Provisioning

Terraform provisions and manages the following AWS resources:

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
Target Groups
EC2 Instances
Amazon ECR
IAM Resources
```

The infrastructure is designed to be repeatable, version-controlled, and consistently deployable across environments.

---

## CI/CD Pipeline

Jenkins automates the application build and deployment lifecycle.

Pipeline flow:

```text
GitHub
   ↓
Jenkins
   ↓
Docker Build
   ↓
Trivy Security Scan
   ↓
Amazon ECR Login
   ↓
Push Image to ECR
   ↓
Dynamic MongoDB IP Discovery
   ↓
AWS Systems Manager Deployment
   ↓
Private App Servers
   ↓
Application Health Check
```

The pipeline ensures that container images are scanned before deployment and that the latest approved image is deployed to the private application servers.

---

## Docker

The application is containerized using Docker.

Docker configuration is available under:

```text
Docker/
├── Dockerfile
├── docker-compose.yml
├── nginx.conf
└── supervisord.conf
```

The container configuration supports the application runtime, frontend delivery, backend services, and process management.

---

## Security

Security is implemented through:

* Public and private subnet separation
* Security Groups with restricted traffic rules
* IAM-based access control
* Private application servers
* Private MongoDB server
* Application Load Balancer as the public entry point
* Trivy container vulnerability scanning
* Amazon ECR for private image storage
* AWS Systems Manager for private server management
* Controlled database access from the application tier

See the detailed security documentation:

```text
docs/security.md
```

---

## Deployment Guide

For complete deployment instructions, see:

```text
docs/deployment.md
```

The deployment guide covers:

```text
AWS CLI Configuration
        ↓
GitHub Repository Clone
        ↓
Terraform Initialization
        ↓
AWS Infrastructure Provisioning
        ↓
Jenkins Setup
        ↓
Docker Image Build
        ↓
Trivy Security Scan
        ↓
Amazon ECR Image Push
        ↓
AWS Systems Manager Deployment
        ↓
Application Load Balancer Testing
        ↓
GitHub Webhook Configuration
        ↓
Automated CI/CD Validation
```

---

## Health Check

The project includes an application health-check script:

```text
scripts/Health-check.sh
```

Make the script executable:

```bash
chmod +x scripts/Health-check.sh
```

Run the health check:

```bash
./scripts/Health-check.sh
```

The script can be used to verify application availability and deployment status.

---

## Key Features

* Secure AWS n-Tier architecture
* Dedicated public, application, and database network tiers
* Private application and database servers
* Two application servers for improved availability
* Application Load Balancer with target-group routing
* Dockerized application deployment
* Terraform-based infrastructure provisioning
* Jenkins-based CI/CD automation
* GitHub webhook integration
* Trivy container image vulnerability scanning
* Amazon ECR image storage
* Dynamic MongoDB private IP discovery
* AWS Systems Manager-based deployment
* Automated application health checks
* Controlled network access using Security Groups and IAM

---

## Author

**Arun Mothe**

Cloud & DevOps Engineer

GitHub: [arunmothe1](https://github.com/arunmothe1)

---

## Project Summary

This project demonstrates an end-to-end automated and secure cloud deployment workflow. Terraform provisions the AWS infrastructure, Docker containerizes the application, Jenkins automates the CI/CD pipeline, Trivy scans container images for vulnerabilities, Amazon ECR stores the approved images, AWS Systems Manager deploys the application to private servers, and the Application Load Balancer distributes traffic across multiple application servers.
