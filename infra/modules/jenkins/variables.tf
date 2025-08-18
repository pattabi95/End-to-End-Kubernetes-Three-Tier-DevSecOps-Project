variable "project" {
  description = "Name of the project"
  type        = string
  default     = "DevSecOpsProject"
}

variable "jenkins_ami" {
  description = "AMI ID for the Jenkins server"
  type        = string
  default     = "ami-020cba7c55df1f615"  
  
}

variable "jenkins_instance_type" {
  description = "Instance type for the Jenkins server"
  type        = string
  default     = "t3.medium"
}   

variable "jenkins_subnet_id" {
  description = "Subnet ID for the Jenkins server"
  type        = string
  default     = "subnet-0bb1c79de3EXAMPLE"  
}   

variable "jenkins_key_name" {
  description = "Key pair name for SSH access to the Jenkins server"
  type        = string
  default     = "ssh"  
  
}   
