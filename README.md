# Project Bedrock — InnovateMart EKS Deployment

## Overview
Production-grade Kubernetes environment on AWS EKS for InnovateMart's
retail microservices application. Built as part of the Karatu 2025 Capstone.

## Live Application
| Service | URL |
|---------|-----|
| Retail Store | http://k8s-retailap-retailst-17d19cf248-759473398.us-east-1.elb.amazonaws.com |

## Architecture
- **VPC**: `project-bedrock-vpc` with public/private subnets across 2 AZs
- **EKS**: `project-bedrock-cluster` (v1.31) with 2x t3.medium nodes
- **Data Layer**: RDS MySQL, RDS PostgreSQL, DynamoDB
- **Ingress**: AWS Load Balancer Controller + ALB
- **Serverless**: S3 + Lambda for asset processing
- **Observability**: CloudWatch + FluentBit

## Repository Structure# Project Bedrock
project-bedrock/
├── .github/workflows/         # CI/CD pipeline
├── terraform/                 # Infrastructure as Code
│   ├── main.tf                # Root module
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/
│       ├── vpc/               # VPC, subnets, NAT
│       ├── eks/               # EKS cluster, node group, OIDC
│       ├── rds/               # MySQL + PostgreSQL
│       ├── dynamodb/          # DynamoDB tables
│       ├── s3/                # Assets bucket
│       ├── lambda/            # Asset processor function
│       └── iam/               # Developer IAM user
├── k8s/                       # Kubernetes manifests
│   ├── namespace.yaml
│   ├── retail-store.yaml
│   ├── ingress.yaml
│   ├── db-secret.yaml
│   └── rbac.yaml
├── lambda/                    # Lambda function code
│   └── asset_processor.py
├── grading.json               # Terraform outputs for grading
└── README.md


## Prerequisites
- AWS CLI configured
- kubectl installed
- helm installed
- Terraform >= 1.5.0

## Deployment Guide

### 1. Trigger CI/CD Pipeline
**Plan (Pull Request):**
- Open a PR against `main` branch
- Pipeline automatically runs `terraform plan`
- Plan output posted as PR comment for review

**Apply (Merge to Main):**
- Merge PR to `main`
- Pipeline automatically runs `terraform apply`

### 2. Configure kubectl
```bash
aws eks update-kubeconfig \
  --name project-bedrock-cluster \
  --region us-east-1
```

### 3. Deploy Application
```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/db-secret.yaml
kubectl apply -f k8s/retail-store.yaml
kubectl apply -f k8s/ingress.yaml
kubectl apply -f k8s/rbac.yaml
```

### 4. Verify Deployment
```bash
kubectl get pods -n retail-app
kubectl get ingress -n retail-app
```

## Required GitHub Secrets
| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS access key |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key |
| `DB_PASSWORD` | RDS database password |

## Grading Credentials
- **Console URL**: https://625272706271.signin.aws.amazon.com/console
- **IAM User**: `bedrock-dev-view`
- **Permissions**: ReadOnly + S3 PutObject on assets bucket
- **K8s RBAC**: view ClusterRole in retail-app namespace

## Verify RBAC
```bash
# Should WORK
kubectl get pods -n retail-app --context bedrock-dev-view

# Should FAIL
kubectl delete pod <pod-name> -n retail-app --context bedrock-dev-view
```

## Test Lambda
```bash
aws s3 cp test-file.jpg \
  s3://bedrock-assets-alt-soe-025-5119/ \
  --profile bedrock-dev-view

aws logs tail /aws/lambda/bedrock-asset-processor --since 5m
```

## CloudWatch Logs
- **EKS Control Plane**: `/aws/eks/project-bedrock-cluster/cluster`
- **Lambda**: `/aws/lambda/bedrock-asset-processor`
- **Application**: `/aws/containerinsights/project-bedrock-cluster/application`

## Teardown
```bash
kubectl delete -f k8s/
cd terraform
terraform destroy -auto-approve -var="db_password=Bedrock2025Secure"
 
 
