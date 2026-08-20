data "aws_ami" "amazon_linux_2023" {
  most_recent = true

  owners = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Jenkins Server
resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.jenkins_instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.jenkins_security_group_id]
  key_name               = var.key_name

  associate_public_ip_address = true

  user_data = file("${path.root}/user-data/bootstrap.sh")

  tags = {
    Name = "${var.project_name}-jenkins"
    Role = "jenkins"
  }
}

# App Server
resource "aws_instance" "app" {
  count = 2

  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.app_instance_type
  subnet_id              = var.app_subnet_id
  vpc_security_group_ids = [var.app_security_group_id]
  key_name               = var.key_name

  associate_public_ip_address = false

  user_data = file("${path.root}/user-data/app-server.sh")

  tags = {
    Name = "${var.project_name}-app-${count.index + 1}"
    Role = "application"
  }
}

# Database Server
resource "aws_instance" "db" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.db_instance_type
  subnet_id              = var.db_subnet_id
  vpc_security_group_ids = [var.db_security_group_id]
  key_name               = var.key_name

  associate_public_ip_address = false

  tags = {
    Name = "${var.project_name}-database"
    Role = "database"
  }
}