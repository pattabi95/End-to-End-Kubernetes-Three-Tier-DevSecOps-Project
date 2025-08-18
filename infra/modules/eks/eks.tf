module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "21.0.6"

    name = var.cluster_name
    kubernetes_version = var.cluster_version
    
    
    subnet_ids = module.vpc.private_subnets

    enable_irsa = true

    vpc_id = module.vpc.vpc_id

    eks_managed_node_groups = {
        node = {
            ami_type        = "AL2_x86_64"
            instance_type   = "t3.medium"
            vpc_security_group_ids = [aws_security_group.worker_node_management.id]
            desired_capacity = 1
            max_capacity     = 2
            min_capacity     = 1
        }
    }
}