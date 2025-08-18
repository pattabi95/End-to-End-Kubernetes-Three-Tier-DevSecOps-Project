terraform {
    required_version = ">= 1.5.0"
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
            region  = var.aws_region
        }
    }
    backend "s3" {
        bucket         = var.backend_bucket
        key            = var.backend_key
        region         = var.backend_region
        dynamodb_table = var.backend_dynamodb_table
        encrypt       = true
    }
}

module "vpc"{
    source = "./modules/vpc"
    vpc_cidr = var.vpc_cidr
    public_subnet_cidr = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
    availability_zone = var.availability_zone
    project = var.project
    aws_region = var.aws_region

}

module "eks" {
  source  = "./modules/eks"
  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  node_instance_type = var.node_instance_type
  desired_capacity = var.desired_capacity
  max_capacity = var.max_capacity
  min_capacity = var.min_capacity

  #passing VPC and subnet information from the VPC module
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  }

module "jenkins" {
  source = "modules/jenkins"
  aws_region = var.aws_region
  
  #passing VPC and subnet information from the VPC module
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
}
