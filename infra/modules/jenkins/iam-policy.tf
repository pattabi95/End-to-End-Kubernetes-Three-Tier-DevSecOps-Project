resource "aws_iam_role_policy_attachment" "jenkins_role_policy" {
    role       = aws_iam_role.jenkins_role.name
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess   "
}   