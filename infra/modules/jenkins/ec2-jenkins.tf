resource "aws_security_group" "jenkins-sg" {
    name        = "jenkins-sg"
    description = "Security group for Jenkins server"
    vpc_id      = aws_vpc.main.id
    
    ingress {
        description = "Jenkins UI access"
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "jenkins" {
    ami           = var.jenkins_ami 
    instance_type = var.jenkins_instance_type
    subnet_id     = aws_subnet.public[0].id
    security_groups = [aws_security_group.jenkins-sg.name]
    key_name      = var.jenkins_key_name
    user_data = file("./modules/jenkins/user_data.sh")
    tags = {
        Name = "${var.project}-jenkins"
    }
}

