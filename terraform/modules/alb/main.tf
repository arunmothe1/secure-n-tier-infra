resource "aws_lb" "main" {
  name               = "secure-n-tier-infra-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    var.alb_security_group_id
  ]

  subnets = var.public_subnet_ids

  tags = {
    Name        = "secure-n-tier-infra-alb"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_lb_target_group" "main" {
  name     = "secure-n-tier-infra-tg"
  port     = var.application_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
    timeout             = 5
  }

  tags = {
    Name = "secure-n-tier-infra-tg"
  }
}

resource "aws_lb_target_group_attachment" "app" {
  count = length(var.app_instance_ids)

  target_group_arn = aws_lb_target_group.main.arn
  target_id        = var.app_instance_ids[count.index]
  port             = var.application_port
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}