resource "aws_security_group" "jenkins-sg" {
    name        = "${var.project}-jenkins-sg"
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
    }}

resource "aws_instance" "jenkins" {
    ami           = "ami-0c02fb55956c7d316" 
    instance_type = "t3.medium"
    subnet_id     = aws_subnet.public[0].id
    security_groups = [aws_security_group.jenkins-sg.name]

  
}