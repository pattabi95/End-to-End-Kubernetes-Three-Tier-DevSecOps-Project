#!/bin/bash
set -e  # Exit on error

echo "[INFO] Updating system packages..."
sudo apt update -y && sudo apt upgrade -y

#######################################
# Install Java (Required for Jenkins)
#######################################
echo "[INFO] Installing Java 17..."
sudo apt install openjdk-17-jre openjdk-17-jdk -y
java --version

#######################################
# Install Jenkins (LTS)
#######################################
echo "[INFO] Installing Jenkins..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
  | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ \
  | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y
sudo apt install jenkins -y

#######################################
# Install Docker (Official Repo)
#######################################
echo "[INFO] Installing Docker..."
sudo apt-get install ca-certificates curl gnupg lsb-release -y
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Add Jenkins and current user to Docker group
sudo usermod -aG docker jenkins
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl restart docker
sudo chmod 666 /var/run/docker.sock

#######################################
# Optional: Run SonarQube in Docker
#######################################
echo "[INFO] Running SonarQube container..."
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community

#######################################
# Install AWS CLI v2
#######################################
echo "[INFO] Installing AWS CLI v2..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install
aws --version

#######################################
# Install kubectl (Latest)
#######################################
echo "[INFO] Installing kubectl (latest stable)..."
KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

#######################################
# Install eksctl
#######################################
echo "[INFO] Installing eksctl..."
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
  | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

#######################################
# Install Terraform
#######################################
echo "[INFO] Installing Terraform..."
wget -O- https://apt.releases.hashicorp.com/gpg \
  | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
  | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install terraform -y
terraform --version

#######################################
# Install Trivy
#######################################
echo "[INFO] Installing Trivy..."
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key \
  | sudo gpg --dearmor -o /usr/share/keyrings/trivy.gpg
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] \
  https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" \
  | sudo tee /etc/apt/sources.list.d/trivy.list
sudo apt update
sudo apt install trivy -y
trivy --version

#######################################
# Install Helm
#######################################
echo "[INFO] Installing Helm..."
sudo snap install helm --classic
helm version

echo "[SUCCESS] All tools installed successfully!"
