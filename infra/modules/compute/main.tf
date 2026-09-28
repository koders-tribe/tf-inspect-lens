data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

data "aws_iam_instance_profile" "existing" {
  name = var.existing_instance_profile_name
}

resource "aws_instance" "this" {
  ami                    = var.existing_ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.existing_security_group_ids
  iam_instance_profile   = data.aws_iam_instance_profile.existing.name

  ebs_optimized               = true
  monitoring                  = false
  associate_public_ip_address = false

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    encrypted             = false
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tags = merge(var.tags, {
    Name        = var.existing_instance_name
    Environment = lookup(var.tags, "Environment", var.name_prefix)
  })
}

resource "aws_lb" "this" {
  count = var.enable_alb ? 1 : 0

  name               = "${var.name_prefix}-alb"
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids
  tags               = merge(var.tags, { Name = "${var.name_prefix}-alb" })
}

resource "aws_lb_target_group" "app" {
  count = var.enable_alb ? 1 : 0

  name     = "${var.name_prefix}-app"
  port     = var.app_host_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = var.tags
}

resource "aws_lb_target_group_attachment" "app" {
  count = var.enable_alb ? 1 : 0

  target_group_arn = aws_lb_target_group.app[0].arn
  target_id        = aws_instance.this.id
  port             = var.app_host_port
}

resource "aws_lb_listener" "http" {
  count = var.enable_alb && var.acm_certificate_arn == "" ? 1 : 0

  load_balancer_arn = aws_lb.this[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app[0].arn
  }
}

resource "aws_lb_listener" "https" {
  count = var.enable_alb && var.acm_certificate_arn != "" ? 1 : 0

  load_balancer_arn = aws_lb.this[0].arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app[0].arn
  }
}

resource "aws_lb_listener" "http_redirect" {
  count = var.enable_alb && var.acm_certificate_arn != "" ? 1 : 0

  load_balancer_arn = aws_lb.this[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
