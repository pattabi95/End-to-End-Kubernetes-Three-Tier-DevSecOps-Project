resource "aws_iam_role" "jenkins_role" {
    name = "${var.project}-jenkins-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
    })
    tags = {
        Name = "${var.project}-jenkins-role"
    }
}