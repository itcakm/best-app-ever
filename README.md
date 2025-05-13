# Three-Layer AWS Architecture with Terraform

This project implements a three-layer architecture in AWS using Terraform:

1. **Web Layer** - Public-facing web servers in public subnets
2. **Application Layer** - Application servers in private subnets
3. **Database Layer** - RDS MySQL database in isolated database subnets

## Architecture Overview

![Three-Tier Architecture](https://raw.githubusercontent.com/aws-samples/aws-three-tier-web-architecture-workshop/main/images/three-tier-architecture.png)

The architecture includes:

- **VPC**: A dedicated VPC with CIDR block 10.0.0.0/16
- **Subnets**: Public, private, and database subnets across multiple availability zones
- **Internet Gateway**: Allows internet access from public subnets
- **NAT Gateway**: Allows internet access from private and database subnets
- **Route Tables**: Configured for each subnet type
- **Security Groups**: Defined for web, application, and database layers
- **Load Balancers**: Application Load Balancers for web and application layers
- **EC2 Instances**: Web servers and application servers
- **RDS Database**: Multi-AZ MySQL database

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform v1.0.0+ installed
- SSH key pair created in AWS (referenced in the configuration)

## Directory Structure

```
infrastructure/
├── main.tf              # Main Terraform configuration
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── modules/
│   ├── networking/      # VPC, subnets, security groups, etc.
│   ├── compute/         # EC2 instances, load balancers
│   └── database/        # RDS database
└── environments/
    ├── dev/             # Development environment configuration
    └── prod/            # Production environment configuration
```

## Deployment Instructions

### Initialize Terraform

```bash
cd infrastructure
terraform init
```

### Deploy to Development Environment

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

### Deploy to Production Environment

```bash
cd environments/prod
terraform init
terraform plan
terraform apply
```

## Security Notes

- In a production environment, improve security by:
  - Using AWS Secrets Manager or Parameter Store for database credentials
  - Restricting SSH access to specific CIDR blocks
  - Implementing a bastion host for SSH access
  - Adding AWS WAF to the web ALB
  - Enabling encryption for all data at rest and in transit

## Clean Up

To destroy all resources:

```bash
cd environments/dev  # or prod
terraform destroy
```
