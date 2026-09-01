# Architecture Documentation

## End-to-End Automated & Secure n-Tier Cloud Infrastructure with Application Deployment

## 1. Overview

This project implements an end-to-end automated and secure n-Tier cloud infrastructure on AWS.

The infrastructure is provisioned using Terraform, the application is containerized using Docker, and Jenkins is used to automate the CI/CD deployment process.

The architecture is designed with network isolation, controlled access, scalability, and automation in mind.

---

## 2. Architecture Goals

The main goals of this architecture are:

- Build a secure AWS cloud infrastructure.
- Separate application and database workloads.
- Avoid direct public access to private resources.
- Automate infrastructure provisioning using Terraform.
- Containerize the application using Docker.
- Store container images in Amazon ECR.
- Automate application deployment using Jenkins.
- Use an Application Load Balancer for traffic distribution.
- Support application scalability using Auto Scaling.
- Use IAM roles and Security Groups for controlled access.
- Use AWS Systems Manager for secure instance management.

---

## 3. High-Level Architecture

The overall architecture consists of the following major layers:

```text
                         Internet
                            |
                            v
                    Internet Gateway
                            |
                            v
              +-------------------------+
              |   Public Subnets        |
              |                         |
              | Application Load        |
              | Balancer (ALB)          |
              +------------+------------+
                           |
                           v
                    Target Group
                           |
                           v
              +-------------------------+
              | Private App Subnets     |
              |                         |
              | EC2 / Auto Scaling      |
              | Application Instances   |
              +------------+------------+
                           |
                           v
              +-------------------------+
              | Private DB Subnets       |
              |                         |
              | MongoDB                 |
              +-------------------------+

                    CI/CD Flow
                         |
                         v
                      GitHub
                         |
                         v
                      Jenkins
                         |
                         v
                    Docker Build
                         |
                         v
                    Amazon ECR
                         |
                         v
                Application Deployment

```

## 4. AWS VPC

A dedicated Amazon VPC is used to isolate the project infrastructure.

The VPC contains multiple subnets and routing components required for secure communication between different application layers.

The VPC provides the network foundation for:

- Application Load Balancer
- Application EC2 instances
- MongoDB
- NAT Gateway
- Internet Gateway
- Route Tables
- Security Groups

---

## 5. Availability Zones

The infrastructure is distributed across Availability Zones where required.

Using multiple Availability Zones improves availability and reduces dependency on a single Availability Zone.

The Application Load Balancer and application instances can operate across multiple Availability Zones.

---

## 6. Public Subnets

Public subnets are used for resources that require controlled internet-facing connectivity.

The Application Load Balancer is deployed in public subnets.

### Public Subnet Traffic Flow

```text
Public Subnet
      |
      v
Route Table
      |
      v
Internet Gateway
      |
      v
Internet
```
## 7. Private Application Subnets

Application EC2 instances are deployed in private subnets.

These instances are responsible for running the application workload.

Private application instances receive traffic through the Application Load Balancer.

### Application Traffic Flow

```text
Internet
   |
   v
Application Load Balancer
   |
   v
Target Group
   |
   v
Private EC2 Instances
```

## 8. Private Database Subnets

MongoDB is deployed in a private network.

The database is not directly accessible from the internet.

Only authorized application resources are allowed to communicate with MongoDB.

### MongoDB Port

```text
27017
```