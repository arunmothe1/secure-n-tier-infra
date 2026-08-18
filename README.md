# 🚀 End-to-End Automated Secure n-Tier Cloud Infrastructure on AWS

[![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.io/)
[![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white)](https://www.jenkins.io/)
[![NodeJS](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)](https://nodejs.org/)

An enterprise-grade, highly available, and secure 3-tier cloud infrastructure provisioned on AWS using Infrastructure as Code (IaC) with **Terraform**, continuous integration and deployment (CI/CD) via **Jenkins**, application containerization with **Docker**, and traffic distribution through an **Application Load Balancer (ALB)**.

---

## 📐 Architecture Overview

```text
                               [ INTERNET ]
                                     │
                                     ▼
                          ┌─────────────────────────┐
                          │    Internet Gateway     │
                          │          (IGW)          │
                          └────────────┬────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ AWS VPC: 10.0.0.0/16                                                        │
│                                                                             │
│  ┌───────────────────────────────────────────────────────────────────────┐  │
│  │ PUBLIC SUBNET: 10.0.1.0/24                                            │  │
│  │                                                                       │  │
│  │         ┌───────────────────┐               ┌───────────────────┐     │  │
│  │         │ Application Load  │               │ Jenkins Control   │     │  │
│  │         │  Balancer (ALB)   │               │   Server (EC2)    │     │  │
│  │         └─────────┬─────────┘               └─────────┬─────────┘     │  │
│  │                   │                                   │               │  │
│  │                   │ Forward Traffic                   │ SSH / Deploy  │  │
│  │                   ▼                                   │               │  │
│  │         ┌───────────────────┐                         │               │  │
│  │         │    NAT Gateway    │                         │               │  │
│  │         │   + Elastic IP    │                         │               │  │
│  │         └─────────┬─────────┘                         │               │  │
│  │                   │                                   │               │  │
│  └───────────────────┼───────────────────────────────────┼───────────────┘  │
│                      │                                   │                  │
│       Internet Access│                                   │                  │
│       for Private EC2│                                   │                  │
│                      ▼                                   ▼                  │
│  ┌───────────────────────────────────────────────────────────────────────┐  │
│  │ PRIVATE APP SUBNET: 10.0.2.0/24                                       │  │
│  │                                                                       │  │
│  │       ┌──────────────────────┐      ┌──────────────────────┐          │  │
│  │       │     App Server 1     │      │     App Server 2     │          │  │
│  │       │    EC2 - Private     │      │    EC2 - Private     │          │  │
│  │       └──────────┬───────────┘      └──────────┬───────────┘          │  │
│  │                  │                             │                      │  │
│  │                  └──────────────┬──────────────┘                      │  │
│  │                                 │                                     │  │
│  │                        Application Traffic                            │  │
│  └─────────────────────────────────┬─────────────────────────────────────┘  │
│                                    │                                        │
│                                    ▼                                        │
│  ┌───────────────────────────────────────────────────────────────────────┐  │
│  │ PRIVATE DB SUBNET: 10.0.3.0/24                                        │  │
│  │                                                                       │  │
│  │                 ┌──────────────────────────┐                          │  │
│  │                 │     Database Server      │                          │  │
│  │                 │      EC2 - Private       │                          │  │
│  │                 └──────────────────────────┘                          │  │
│  │                                                                       │  │
│  └───────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## ✨ Key Features & Highlights

* **Infrastructure as Code (IaC):** Modularized Terraform configuration ensuring rapid, repeatable, and automated provisioning of AWS resources.
* **Network Security & Isolation:** Custom VPC design utilizing isolated Public, Private Application, and Private Database subnets across Availability Zones.
* **Zero Direct Public Exposure:** Backend Application servers and Database run exclusively in private subnets behind an Application Load Balancer and NAT Gateway.
* **Granular Least-Privilege Security Groups:** Strict stateful firewall rules restricting inter-tier communication (e.g., DB tier accepts connections strictly from the App tier).
* **Unified Containerization:** Multi-stage Docker builds packing React frontend and Node.js backend components into lightweight production-ready containers.
* **Automated CI/CD Pipeline:** Jenkins declarative pipeline orchestrating code checks, container creation, registry uploads, rolling updates, and post-deployment health checks.

---

## 🛠️ Technology Stack

| Category | Technology | Usage |
| :--- | :--- | :--- |
| **Cloud Provider** | AWS (Amazon Web Services) | Core Cloud Infrastructure |
| **IaC** | Terraform | Infrastructure Provisioning & Management |
| **Containers** | Docker, Docker Compose | Application Packaging & Local Orchestration |
| **CI/CD** | Jenkins | Continuous Integration & Continuous Deployment |
| **Load Balancing** | AWS Application Load Balancer (ALB) | Web Traffic Distribution & Target Health Checks |
| **Operating System** | Amazon Linux 2023 | EC2 Compute Nodes |
| **Languages & Web** | Node.js, Express, React, Nginx, Bash | Application Stack & System Automation Scripts |

---

## 📁 Repository Structure

```text
End-to-End-Automated-Secure-n-Tier-Cloud-Infrastructure-with-Application-Deployment/
├── README.md                           # Project Documentation
├── .gitignore                          # Git Exclusion File
├── application/                        # Source Code
│   ├── frontend/                       # React Frontend Component
│   └── backend/                        # Node.js Express API Server
├── docker/                             # Container Specifications
│   ├── Dockerfile                      # Unified Multi-Stage Production Build
│   └── docker-compose.yml              # Local Development Stack
├── jenkins/                            # Automation Pipelines
│   └── Jenkinsfile                     # Declarative Deployment Pipeline
├── scripts/                            # Helper & Health Check Scripts
│   ├── install-docker.sh               # Local Docker Setup
│   ├── install-terraform.sh            # Local Terraform Setup
│   └── health-check.sh                 # Endpoint Verification Script
├── docs/                               # Architecture Specifications
│   ├── architecture.png                # Visual Architecture Diagram
│   ├── security.md                     # Security Design & Controls
│   └── deployment.md                   # Detailed Operating Procedures
└── terraform/                          # Infrastructure Configuration
    ├── provider.tf                     # AWS Provider & HashiCorp Config
    ├── variables.tf                    # Parameter Declarations
    ├── terraform.tfvars.example        # Environment Variables Template
    ├── vpc.tf                          # Virtual Private Cloud Definition
    ├── subnet.tf                       # Public & Private Subnet Routing
    ├── internet-gateway.tf             # Edge Internet Access Gateway
    ├── nat-gateway.tf                  # Outbound Internet Access for Private Subnets
    ├── route-table.tf                  # Traffic Control Route Tables
    ├── security-group.tf               # Stateful Firewall Definitions
    ├── ec2.tf                          # Compute Resource Specifications (3 Nodes)
    ├── alb.tf                          # Application Load Balancer & Target Groups
    ├── outputs.tf                      # Infrastructure Endpoint Outputs
    └── userdata/                       # Startup Configuration Scripts
```


## 🚀 Quick Start Deployment Guide

---

## ⚙️ Prerequisites

Before running Terraform commands, ensure you have:

- **Terraform CLI** (>= v1.5.0) installed.
- **AWS CLI** configured with valid IAM credentials.
- Appropriate AWS IAM permissions for VPC, EC2, Security Groups, and ALB provisioning.
 - 🚀 [Deployment Guide](docs/deployment.md)
---



## 📚 Documentation

Project documentation and architecture references:

- 🏗️ [Architecture Diagram](docs/architecture.png)
- 🚀 [Deployment Guide](docs/deployment.md)
- 🔐 [Security Design](docs/security.md)

---

## 👨‍💻 Author

**Arun Mothe**  
* Cloud & DevOps Engineer  
* GitHub: [@arunmothe1](https://github.com/arunmothe1)