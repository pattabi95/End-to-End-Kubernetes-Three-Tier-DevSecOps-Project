terraform {
    backend "s3" {
        bucket         = "s3-bucket-jenkins"
        key            = "ssh"
        region         = "us-east-1"
        dynamodb_table = "terraform-state-lock"
        encrypt        = true
    }
    required_version = ">= 1.5.0"
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
            region  = var.aws_region
        }
    }
}  
