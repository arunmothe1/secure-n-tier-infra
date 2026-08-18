data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# 1. Jenkins Control Server (Public Subnet) - 1st EC2
resource "aws_instance" "jenkins" {
  ami                         = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type               = var.jenkins_instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.jenkins_security_group_id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = file("${path.root}/user-data/bootstrap.sh")

  tags = {
    Name        = "${var.project_name}-jenkins-server"
    Role        = "jenkins-controller"
    Environment = var.environment
  }
}

# 2. Application Servers (Private Subnets) - 2nd & 3rd EC2
resource "aws_instance" "app" {
  count                       = length(var.app_subnet_ids)
  ami                         = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type               = var.app_instance_type
  subnet_id                   = var.app_subnet_ids[count.index]
  vpc_security_group_ids      = [var.app_security_group_id]
  key_name                    = var.key_name
  associate_public_ip_address = false

  user_data = file("${path.root}/user-data/app-server.sh")

  tags = {
    Name        = "${var.project_name}-app-${count.index + 1}"
    Role        = "application"
    Environment = var.environment
  }
}

# 3. Database Server (Private DB Subnet) - 4th EC2
resource "aws_instance" "db" {
  ami                         = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type               = var.db_instance_type
  subnet_id                   = var.db_subnet_id
  vpc_security_group_ids      = [var.db_security_group_id]
  key_name                    = var.key_name
  associate_public_ip_address = false

  user_data = <<-EOF
#!/bin/bash
set -e
dnf update -y
dnf install -y docker
systemctl enable --now docker
usermod -aG docker ec2-user
mkdir -p /data/mongodb
docker run -d --name mongodb --restart unless-stopped -p 27017:27017 -v /data/mongodb:/data/db mongo:7
EOF

  tags = {
    Name        = "${var.project_name}-database"
    Role        = "database"
    Environment = var.environment
  }
}