# Security Design

## End-to-End Automated & Secure n-Tier Cloud Infrastructure

This document describes the security architecture, network isolation, access controls, and security practices implemented in the AWS infrastructure.

The security model follows a **defense-in-depth** approach where each infrastructure layer has controlled access based on its role and communication requirements.

---

## 1. Security Objectives

The infrastructure is designed with the following security objectives:

- Protect infrastructure from unauthorized access
- Isolate application and database tiers
- Minimize publicly exposed resources
- Control inbound and outbound network traffic
- Apply least-privilege access
- Protect credentials and sensitive configuration
- Secure CI/CD operations
- Maintain separation between infrastructure layers

---

## 2. Security Architecture

```text
                         INTERNET
                            │
                            │ HTTP / HTTPS
                            ▼
                  ┌────────────────────┐
                  │ Application Load   │
                  │     Balancer       │
                  └─────────┬──────────┘
                            │
                     Application
                       Traffic
                            │
                            ▼
              ┌──────────────────────────┐
              │    PRIVATE APP TIER      │
              │                          │
              │  ┌────────┐  ┌────────┐  │
              │  │ App-01 │  │ App-02 │  │
              │  └────┬───┘  └───┬────┘  │
              └───────┼──────────┼────────┘
                      │          │
                      └────┬─────┘
                           │
                    Database Traffic
                           │
                           ▼
              ┌──────────────────────────┐
              │     PRIVATE DB TIER      │
              │                          │
              │      ┌──────────┐        │
              │      │ Database │        │
              │      └──────────┘        │
              └──────────────────────────┘

Private App Tier ───────► NAT Gateway
                              │
                              ▼
                       Internet Gateway
                              │
                              ▼
                           Internet
```

---

# 3. Network Security

The VPC is segmented into separate network tiers.

```text
VPC
│
├── Public Tier
│   ├── Application Load Balancer
│   ├── Jenkins Server
│   └── NAT Gateway
│
├── Private Application Tier
│   ├── Application Server 01
│   └── Application Server 02
│
└── Private Database Tier
    └── Database Server
```

### Security Boundaries

| Tier | Purpose | Direct Internet Inbound |
|---|---|---|
| Public | Internet-facing and management components | Controlled |
| Private Application | Application workloads | No |
| Private Database | Data storage | No |

The application and database tiers are intentionally isolated from direct internet access.

---

# 4. Internet Gateway

The Internet Gateway provides connectivity between the VPC and the internet for resources deployed in public subnets.

```text
Internet
    │
    ▼
Internet Gateway
    │
    ▼
Public Subnet
```

Only resources that require public connectivity should be placed in public subnets.

---

# 5. NAT Gateway

Private application instances require outbound internet connectivity for operations such as:

- Package installation
- Operating system updates
- Docker image retrieval
- External API communication

This outbound traffic is routed through the NAT Gateway.

```text
Private Application EC2
          │
          ▼
     NAT Gateway
          │
          ▼
 Internet Gateway
          │
          ▼
       Internet
```

Private instances do not receive unsolicited inbound connections through the NAT Gateway.

---

# 6. Security Group Design

Security Groups are used as the primary instance-level network access control mechanism.

The security model follows:

```text
Internet
   │
   ▼
ALB Security Group
   │
   ▼
Application Security Group
   │
   ▼
Database Security Group
```

Each tier accepts traffic only from the required source.

---

## 6.1 ALB Security Group

The Application Load Balancer is the public entry point for the application.

Allowed traffic:

```text
HTTP   → TCP 80
HTTPS  → TCP 443
```

Example:

```text
Internet
   │
   │ 80 / 443
   ▼
ALB
```

No database or internal application ports should be exposed through the ALB.

---

## 6.2 Application Security Group

Application servers are deployed in private subnets.

Application traffic should be accepted only from the ALB Security Group.

```text
ALB Security Group
        │
        │ Application Port
        ▼
Application Security Group
        │
        ▼
Application EC2
```

This prevents direct public access to application instances.

---

## 6.3 Database Security Group

The database tier is isolated from the internet.

Database traffic is allowed only from the application tier.

```text
Application Security Group
          │
          │ Database Port
          ▼
Database Security Group
          │
          ▼
      Database
```

The database should never be configured with unrestricted inbound access:

```text
0.0.0.0/0
```

---

# 7. Port-Level Security

Only required ports should be opened.

| Component | Port | Source | Purpose |
|---|---:|---|---|
| ALB | 80 | Internet | HTTP |
| ALB | 443 | Internet | HTTPS |
| Application | Application Port | ALB SG | Application traffic |
| Database | Database Port | App SG | Database communication |
| SSH | 22 | Trusted source | Administration |
| Jenkins | 8080* | Trusted source | Jenkins administration |

> `8080` is shown as an example for Jenkins administration. In a production environment, Jenkins should preferably be placed behind controlled access and HTTPS.

---

# 8. SSH Security

SSH access is restricted to trusted administrative sources.

Avoid:

```text
SSH
22
0.0.0.0/0
```

Recommended access model:

```text
Administrator
      │
      ▼
Controlled Management Access
      │
      ▼
EC2
```

Private application and database instances should not require direct public SSH access.

---

# 9. IAM Security

AWS IAM follows the **Principle of Least Privilege**.

Each AWS identity should receive only the permissions required to perform its intended operation.

### IAM Controls

- Avoid using the AWS root account for daily operations
- Use IAM roles where possible
- Grant only required permissions
- Avoid wildcard permissions when unnecessary
- Rotate credentials when applicable
- Remove unused credentials
- Review IAM permissions regularly

---

# 10. Jenkins Security

Jenkins is part of the CI/CD infrastructure and therefore requires strict credential management.

Sensitive credentials should be stored in:

```text
Jenkins Credentials Manager
```

Never hard-code credentials inside:

```text
Jenkinsfile
Shell Scripts
Terraform Files
Application Source Code
Dockerfiles
```

The pipeline should retrieve credentials securely at runtime.

---

# 11. Secrets Management

Sensitive information must never be committed to the Git repository.

Examples of sensitive information:

```text
AWS Access Keys
AWS Secret Keys
Private SSH Keys
Database Passwords
JWT Secrets
API Tokens
Application Credentials
```

Sensitive files should be excluded using `.gitignore`.

Example:

```text
*.pem
.env
terraform.tfvars
terraform.tfstate
terraform.tfstate.backup
.terraform/
```

For production workloads, use:

```text
AWS Secrets Manager
AWS Systems Manager Parameter Store
Jenkins Credentials Manager
```

---

# 12. Terraform Security

Terraform is used to provision infrastructure through Infrastructure as Code.

Security considerations include:

- Never hard-code AWS credentials
- Avoid committing sensitive Terraform variables
- Protect Terraform state
- Use remote state for shared environments
- Restrict access to the Terraform state
- Review `terraform plan` before applying changes
- Apply changes through controlled workflows

Terraform state may contain sensitive infrastructure information and must be treated as sensitive data.

---

# 13. Docker Security

Docker is used for application packaging and deployment.

Security practices include:

- Use trusted base images
- Keep base images updated
- Minimize installed packages
- Avoid running containers as root where possible
- Do not embed secrets into images
- Do not copy sensitive files into images
- Scan images for vulnerabilities
- Remove unnecessary build artifacts

Application secrets should be injected during deployment rather than baked into Docker images.

---

# 14. CI/CD Security

The CI/CD pipeline follows controlled stages:

```text
GitHub
   │
   ▼
Jenkins
   │
   ├── Source Validation
   ├── Application Build
   ├── Testing
   ├── Docker Image Build
   ├── Image Push
   └── Deployment
```

Security controls should be applied at each stage.

### Source

- Trusted repository
- Protected branches
- Review changes before deployment

### Build

- Validate dependencies
- Run application tests
- Avoid exposing secrets in build logs

### Container

- Build trusted images
- Scan images
- Use versioned image tags

### Deployment

- Use controlled credentials
- Deploy only to authorized infrastructure
- Perform health checks after deployment

---

# 15. Application Security

The application tier is protected by network-level controls and controlled access.

Application servers:

- Run inside private subnets
- Are accessed through the ALB
- Do not require direct public access
- Communicate with the database through restricted rules

Application-level security should also include:

- Input validation
- Authentication and authorization
- Secure password storage
- HTTPS
- Secure HTTP headers
- Dependency updates

---

# 16. Database Security

The database is deployed in the private tier.

Security model:

```text
Internet
   │
   X
   │
   X  No direct database access
   │
Application Tier
   │
   │ Allowed Database Traffic
   ▼
Database Tier
```

Database access should be restricted by:

- Security Group
- Private subnet
- Database authentication
- Strong credentials
- Restricted network sources

---
<!--
# 17. Logging and Monitoring

Security-related infrastructure events should be monitored.

Recommended AWS services:

```text
CloudWatch
CloudTrail
VPC Flow Logs
```

Monitoring should cover:

- EC2 health
- Application availability
- Load Balancer health
- Authentication events
- Infrastructure changes
- Network traffic
- Failed access attempts

---
<!--
# 18. Security Monitoring Flow

```text
AWS Infrastructure
        │
        ├──────────────► CloudWatch
        │
        ├──────────────► CloudTrail
        │
        └──────────────► VPC Flow Logs
                              │
                              ▼
                       Security Monitoring
```
-->

---

# 19. Data Protection

Sensitive application and infrastructure data should be protected using encryption where applicable.

Recommended controls:

- Encryption at rest
- Encryption in transit
- TLS/HTTPS
- Encrypted storage
- Secure secret management
- Restricted access to sensitive data

---

# 20. Defense-in-Depth Model

The project uses multiple security layers:

```text
┌─────────────────────────────────────────┐
│              Internet Security          │
│             HTTPS / ALB / WAF           │
├─────────────────────────────────────────┤
│              Network Security           │
│        VPC / Subnets / Route Tables     │
├─────────────────────────────────────────┤
│             Access Security             │
│       IAM / Security Groups / SSH       │
├─────────────────────────────────────────┤
│            Application Security         │
│     Authentication / Validation / TLS   │
├─────────────────────────────────────────┤
│             Container Security          │
│        Docker / Image Scanning          │
├─────────────────────────────────────────┤
│              Data Security              │
│       Encryption / Secrets Management   │
└─────────────────────────────────────────┘
```

---

# 21. Security Checklist

Before deployment:

```text
[ ] VPC CIDR reviewed
[ ] Public and private subnets configured
[ ] Database placed in private subnet
[ ] Security Groups reviewed
[ ] SSH restricted
[ ] IAM permissions reviewed
[ ] No AWS credentials in source code
[ ] No private keys committed
[ ] No .env files committed
[ ] Terraform state protected
[ ] Jenkins credentials stored securely
[ ] Docker images reviewed
[ ] Application secrets protected
```

---

# 22. Security Principles

The infrastructure follows these core principles:

1. **Least Privilege**
2. **Network Segmentation**
3. **Private-by-Default Application Architecture**
4. **Restricted Security Group Rules**
5. **Secure Credential Management**
6. **Defense in Depth**
7. **Controlled CI/CD Access**
8. **No Hard-Coded Secrets**
9. **Continuous Monitoring**
10. **Separation of Application and Database Tiers**

---

## Security Summary

The architecture minimizes the attack surface by exposing only the required entry points to the internet while keeping application and database workloads inside private network tiers.

Traffic is controlled through Security Groups, administrative access is restricted, IAM follows least privilege, secrets are separated from application code, and CI/CD operations are managed through Jenkins credentials.

This layered approach provides a secure foundation for deploying and operating the application on AWS.
