# Terraform Infrastructure

This directory contains the Terraform configuration used to provision the AWS infrastructure for the Secure N-Tier project.

---

## Overview

Terraform is used as Infrastructure as Code (IaC) to create and manage:

```text
AWS VPC
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

---

## Directory Structure

```text
terraform/
│
├── modules/
│   ├── alb/
│   ├── ec2/
│   ├── ecr/
│   ├── security-group/
│   └── vpc/
│
├── data.tf
├── locals.tf
├── main.tf
├── outputs.tf
├── providers.tf
├── variables.tf
├── versions.tf
├── terraform.tfvars.example
└── README.md
```

---

## Terraform Modules

### VPC Module

The VPC module creates the core networking infrastructure.

```text
modules/vpc/
```

Includes:

* VPC
* Public Subnets
* Private Application Subnets
* Private Database Subnet
* Internet Gateway
* NAT Gateway
* Route Tables

---

### Security Group Module

```text
modules/security-group/
```

Creates the Security Groups required for:

* ALB
* Jenkins
* Application Servers
* MongoDB

---

### EC2 Module

```text
modules/ec2/
```

Creates the required EC2 instances.

The project includes:

```text
Jenkins Server
App Server 1
App Server 2
MongoDB Server
```

---

### ALB Module

```text
modules/alb/
```

Creates:

```text
Application Load Balancer
Target Group
Listeners
Target Registration
```

---

### ECR Module

```text
modules/ecr/
```

Creates the Amazon ECR repository used to store application Docker images.

---

## Terraform Files

| File                       | Purpose                                |
| -------------------------- | -------------------------------------- |
| `main.tf`                  | Main Terraform configuration           |
| `providers.tf`             | AWS provider configuration             |
| `versions.tf`              | Terraform/provider version constraints |
| `variables.tf`             | Input variables                        |
| `locals.tf`                | Local values                           |
| `data.tf`                  | AWS data sources                       |
| `outputs.tf`               | Infrastructure outputs                 |
| `terraform.tfvars.example` | Example input values                   |

---

## Prerequisites

Install:

```text
Terraform
AWS CLI
Git
```

Verify:

```bash
terraform --version
aws --version
git --version
```

Configure AWS:

```bash
aws configure
```

Verify:

```bash
aws sts get-caller-identity
```

---

## Configure Variables

Create a local Terraform variables file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit:

```bash
nano terraform.tfvars
```

Example:

```hcl
key_name = "your-key-pair-name"
```

Do not commit sensitive values to GitHub.

---

## Initialize Terraform

```bash
terraform init
```

---

## Format Terraform

```bash
terraform fmt -recursive
```

---

## Validate Configuration

```bash
terraform validate
```

Expected:

```text
Success! The configuration is valid.
```

---

## Review Plan

```bash
terraform plan
```

Review all resources before applying.

---

## Apply Infrastructure

```bash
terraform apply
```

Confirm:

```text
yes
```

Terraform will create the infrastructure.

---

## View Outputs

```bash
terraform output
```

Important outputs may include:

```text
VPC ID
ALB DNS
Jenkins Public IP
Application Server IDs
MongoDB Instance ID
ECR Repository
```

---

## Destroy Infrastructure

To remove all Terraform-managed infrastructure:

```bash
terraform destroy
```

Confirm:

```text
yes
```

> Use `terraform destroy` carefully because it permanently removes the managed infrastructure.

---

## Recommended Terraform Workflow

```text
terraform init
      ↓
terraform fmt
      ↓
terraform validate
      ↓
terraform plan
      ↓
terraform apply
      ↓
terraform output
```

---

## Infrastructure Architecture

```text
AWS VPC
│
├── Public Subnet
│   ├── Application Load Balancer
│   └── Jenkins EC2
│
├── Private Application Subnet
│   ├── App Server 1 EC2
│   └── App Server 2 EC2
│
└── Private Database Subnet
    └── MongoDB EC2
```

---

## Terraform Security

Do not commit the following files or directories:

```text
.terraform/
terraform.tfstate
terraform.tfstate.backup
terraform.tfvars
Private Keys
Secret Files
```

Keep only:

```text
terraform.tfvars.example
```

in the Git repository as an example configuration.

---

## Terraform and CI/CD Integration

Terraform provisions the infrastructure required by the CI/CD pipeline.

```text
Terraform
    ↓
AWS Infrastructure
    ↓
Jenkins
    ↓
Docker
    ↓
Trivy
    ↓
Amazon ECR
    ↓
AWS Systems Manager
    ↓
App Servers
```

---

## Result

Terraform provides a repeatable and consistent way to provision the complete AWS infrastructure for the Secure N-Tier application.


## 📸 Infrastructure Verification & Proof

All infrastructure verification screenshots are available in:

`terraform/screenshots/`

📸 [Terraform Infrastructure Screenshots](docs/images/Infra)

The screenshots provide proof of the provisioned AWS infrastructure and its configuration.

Check the folder for:

- Terraform Apply
- VPC
- Subnets
- Internet Gateway
- NAT Gateway
- EC2 Instances
- Application Load Balancer
- Target Group
- Auto Scaling Group
- Security Groups
- Amazon ECR
- Terraform Outputs
- Terraform Destroy