terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "project-bedrock-tfstate-625272706271"
    key    = "project-bedrock/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project = "karatu-2025-capstone"
    }
  }
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  aws_region   = var.aws_region
}

module "eks" {
  source             = "./modules/eks"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
}

module "rds" {
  source             = "./modules/rds"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  eks_node_sg_id     = module.eks.node_security_group_id
  db_password        = var.db_password
}

module "dynamodb" {
  source       = "./modules/dynamodb"
  project_name = var.project_name
}

module "lambda" {
  source        = "./modules/lambda"
  project_name  = var.project_name
  s3_bucket_arn = module.s3.assets_bucket_arn
  s3_bucket_id  = module.s3.assets_bucket_id
}

module "s3" {
  source               = "./modules/s3"
  project_name         = var.project_name
  student_id           = var.student_id
  lambda_function_arn  = module.lambda.lambda_function_arn
  lambda_permission_id = module.lambda.lambda_permission_id
}

module "iam" {
  source            = "./modules/iam"
  project_name      = var.project_name
  assets_bucket_arn = module.s3.assets_bucket_arn
}
