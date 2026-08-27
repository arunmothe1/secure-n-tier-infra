# Security Documentation

## 1. Security Overview

This project follows a layered security approach using AWS network isolation, Security Groups, IAM, private subnets, Trivy, and AWS Systems Manager.

The main security objective is to keep application and database servers private while exposing only the required public components.

---

## 2. Network Segmentation

The AWS VPC is divided into three subnet tiers:

```text
AWS VPC
│
├── Public Subnet
│   ├── Application Load Balancer
│   └── Jenkins Server
│
├── Private Application Subnet
│   ├── App Server 1
│   └── App Server 2
│
└── Private Database Subnet
    └── MongoDB Server
```

This separation reduces unnecessary direct network exposure.

---

## 3. Public Subnet Security

The Public Subnet contains:

* Application Load Balancer
* Jenkins Server

The ALB acts as the public entry point for application traffic.

The application servers and MongoDB server are not exposed directly to the internet.

---

## 4. Private Application Servers

App Server 1 and App Server 2 are deployed in the Private Application Subnet.

They run the application using Docker containers.

```text
Internet
   ↓
ALB
   ↓
Private App Servers
```

Only required traffic from the ALB and deployment mechanisms should be permitted.

---

## 5. Private Database Server

MongoDB is deployed in the Private Database Subnet.

The database server does not require direct public internet access.

Database communication is restricted to the required application tier.

```text
App Server
    ↓
MongoDB
```

---

## 6. Security Groups

Security Groups act as virtual firewalls.

Traffic should be restricted based on source, destination, protocol, and port.

Example:

```text
Internet
   ↓
ALB
   └── HTTP/HTTPS

ALB
   ↓
App Servers
   └── Application Port

App Servers
   ↓
MongoDB
   └── Port 27017
```

Only required ports should be allowed.

---

## 7. IAM

AWS IAM is used to control access to AWS resources.

IAM permissions are applied according to the required role of each resource.

Examples:

```text
Jenkins
   ↓
AWS APIs
   ↓
ECR / EC2 / SSM
```

Application servers use AWS permissions required for image retrieval and deployment-related operations.

---

## 8. Amazon ECR Security

Amazon ECR is used as the private container image registry.

```text
Docker Image
     ↓
Amazon ECR
     ↓
Private App Servers
```

Only authorized AWS identities should have permission to push or pull images.

---

## 9. Docker Image Security

Trivy is used to scan Docker images before deployment.

Example:

```bash
trivy image <image-name>
```

The CI/CD pipeline checks for high and critical vulnerabilities.

```text
Docker Build
     ↓
Trivy Scan
     ↓
Security Check
     ↓
Continue Deployment
```

---

## 10. AWS Systems Manager

AWS Systems Manager is used to manage private application servers without requiring direct public exposure.

Deployment flow:

```text
Jenkins
   ↓
AWS Systems Manager
   ↓
Private App Servers
```

This reduces the need for direct public SSH access to application servers.

---

## 11. SSH

SSH is used for administrative access to the Jenkins Server when required.

Example:

```bash
ssh -i your-key.pem ec2-user@JENKINS_PUBLIC_IP
```

Private application servers do not need to be publicly exposed for deployment.

---

## 12. NAT Gateway

NAT Gateway allows private resources to initiate outbound internet connections without allowing direct inbound internet connections.

```text
Private Subnet
      ↓
NAT Gateway
      ↓
Internet Gateway
      ↓
Internet
```

---

## 13. Internet Gateway

The Internet Gateway provides internet connectivity for resources in the public subnet.

```text
Internet
   ↓
Internet Gateway
   ↓
Public Subnet
```

---

## 14. Application Load Balancer

The ALB is the public entry point for the application.

```text
Internet
   ↓
ALB
   ↓
Target Group
   ↓
App Server 1 / App Server 2
```

The application servers remain private.

---

## 15. Database Protection

MongoDB is placed in a dedicated private database subnet.

Security Groups should allow MongoDB traffic only from the required application servers.

Example:

```text
App Server Security Group
          ↓
   MongoDB Port 27017
          ↓
MongoDB Security Group
```

No public access should be configured for MongoDB.

---

## 16. Secrets and Credentials

Do not store:

```text
AWS Access Keys
AWS Secret Keys
Private SSH Keys
Database Passwords
JWT Secrets
```

directly in GitHub source code.

Use:

* Environment variables
* AWS IAM roles
* Jenkins credentials
* AWS Secrets Manager or another secure secret-management solution where required

---

## 17. Terraform Security

Terraform configuration should not contain hard-coded sensitive credentials.

Sensitive values should be supplied through appropriate variables or secure credential mechanisms.

Do not commit:

```text
terraform.tfstate
terraform.tfstate.backup
.terraform/
Private Keys
Secret Files
```

to the Git repository.

---

## 18. Security Verification Checklist

```text
✓ Public and private subnet separation
✓ Private App Servers
✓ Private MongoDB Server
✓ Security Groups configured
✓ IAM permissions configured
✓ ALB used as public application entry point
✓ NAT Gateway configured for private outbound access
✓ Docker image scanned with Trivy
✓ ECR used as private image registry
✓ SSM used for private server management
✓ Sensitive credentials excluded from Git
✓ Terraform state protected from public exposure
```

---

## 19. Security Architecture

```text
                       INTERNET
                           │
                           ▼
                         ALB
                           │
                    Application Traffic
                           │
              ┌────────────┴────────────┐
              ▼                         ▼
         App Server 1              App Server 2
         Private Subnet            Private Subnet
              │                         │
              └────────────┬────────────┘
                           ▼
                       MongoDB
                     Private Subnet


GitHub
   ↓
Jenkins
   ↓
Trivy
   ↓
Amazon ECR
   ↓
AWS Systems Manager
   ↓
Private App Servers
```

---

## 20. Security Goal

The architecture follows the principle of **minimum exposure and controlled access**:

```text
Public Access
     ↓
     ALB
     ↓
Private Application Tier
     ↓
Private Database Tier
```

Only the components that require public access are exposed publicly.
