data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

data "aws_iam_policy_document" "ec2_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance" {
  name               = "${var.name_prefix}-ec2"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
  tags               = merge(var.tags, { Name = "${var.name_prefix}-ec2" })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "ecr_pull" {
  statement {
    sid       = "EcrAuth"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  # An empty resources list is an invalid policy, so skip when ECR is off.
  dynamic "statement" {
    for_each = length(var.ecr_repository_arns) > 0 ? [1] : []

    content {
      sid = "EcrPull"
      actions = [
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:DescribeRepositories",
        "ecr:DescribeImages",
      ]
      resources = var.ecr_repository_arns
    }
  }
}

resource "aws_iam_role_policy" "ecr_pull" {
  name   = "ecr-pull"
  role   = aws_iam_role.instance.id
  policy = data.aws_iam_policy_document.ecr_pull.json
}

# e.g. the app's scoped S3 + SES policy, so the API can use the instance role
# instead of static keys. count, not for_each: the ARNs are unknown until apply
# in a new account, but the list length is known.
resource "aws_iam_role_policy_attachment" "extra" {
  count = length(var.extra_policy_arns)

  role       = aws_iam_role.instance.name
  policy_arn = var.extra_policy_arns[count.index]
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name_prefix}-ec2"
  role = aws_iam_role.instance.name
  tags = var.tags
}

resource "aws_security_group_rule" "ssh" {
  count = length(var.allowed_ssh_cidrs) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ssh_cidrs
  security_group_id = var.app_security_group_id
  description       = "Optional SSH; prefer SSM"
}

data "aws_subnet" "this" {
  id = var.subnet_id
}

locals {
  uploads_enabled = var.uploads_volume_gb > 0

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    deploy_path       = var.deploy_path
    uploads_mount     = var.uploads_mount_path
    uploads_volume_id = local.uploads_enabled ? aws_ebs_volume.uploads[0].id : ""
    swap_gb           = var.swap_gb
  })

  public_ip = var.enable_eip ? aws_eip.this[0].public_ip : aws_instance.this.public_ip
  api_url = (
    var.enable_alb ? (var.acm_certificate_arn != "" ? "https://${aws_lb.this[0].dns_name}" : "http://${aws_lb.this[0].dns_name}") :
    var.public_http ? "http://${local.public_ip}:${var.app_host_port}" :
    null
  )
}

resource "aws_instance" "this" {
  ami                    = data.aws_ssm_parameter.al2023.value
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.app_security_group_id]
  iam_instance_profile   = aws_iam_instance_profile.this.name
  user_data              = local.user_data

  root_block_device {
    volume_size           = var.root_volume_gb
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-app"
    Environment = lookup(var.tags, "Environment", var.name_prefix)
  })

  # The AMI comes from the "latest AL2023" parameter; without this every new
  # AMI release would replace the instance. user_data only runs on first boot.
  # Replace the instance deliberately to pick up either change.
  lifecycle {
    ignore_changes = [ami, user_data]
  }
}

# Stable public IP across stop/start (the auto-assigned one changes).
resource "aws_eip" "this" {
  count = var.enable_eip ? 1 : 0

  domain   = "vpc"
  instance = aws_instance.this.id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-app"
  })
}

# Created before the instance (in the subnet's AZ) so user_data can mount it by
# volume ID.
resource "aws_ebs_volume" "uploads" {
  count = local.uploads_enabled ? 1 : 0

  availability_zone = data.aws_subnet.this.availability_zone
  size              = var.uploads_volume_gb
  type              = "gp3"
  encrypted         = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-uploads"
  })
}

resource "aws_volume_attachment" "uploads" {
  count = local.uploads_enabled ? 1 : 0

  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.uploads[0].id
  instance_id = aws_instance.this.id
}

moved {
  from = aws_ebs_volume.uploads
  to   = aws_ebs_volume.uploads[0]
}

moved {
  from = aws_volume_attachment.uploads
  to   = aws_volume_attachment.uploads[0]
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
