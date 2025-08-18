variable "project" {
  description = "The name of the project"
  type        = string
  default     = "DevSecOpsProject"
  
}

variable "backend_bucket" {
  description = "S3 bucket for Terraform state"
  type        = string
  default     = "tf-state-bucket" 
}   

variable "backend_key" {
  description = "S3 key for Terraform state"
  type        = string
  default     = "terraform/state"
}

variable "backend_region" {
  description = "AWS region for the backend S3 bucket"
  type        = string
  default     = "us-east-1"
  
}

variable "backend_dynamodb_table" {
  description = "DynamoDB table for Terraform state locking"
  type        = string
  default     = "tf-lock-table"
  
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = ["10.0.1.0/24" , "10.0.2.0/24"]
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = ["10.0.3.0/24" , "10.0.4.0/24"]
}

variable "availability_zone" {
  description = "Availability zone for the subnets"
  type        = string
  default     = "us-east-1a"
 }

variable "aws_region" {
  description = "AWS region for the resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"   
 }