resource "iam_instance_profile" "jenkins_instance_profile" {
    name = "${var.project}-jenkins-instance-profile"
    role = aws_iam_role.jenkins_role.name
    tags = {
        Name = "${var.project}-jenkins-instance-profile"
    }
}