data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_openid_connect_provider" "github" {
  count = var.create_oidc_provider ? 0 : 1
  url   = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
  count = var.create_oidc_provider ? 1 : 0

  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["ffffffffffffffffffffffffffffffffffffffff"]

  tags = merge(var.tags, {
    Name = "github-actions"
  })

  lifecycle {
    ignore_changes = [thumbprint_list]
  }
}

locals {
  oidc_provider_arn = var.create_oidc_provider ? aws_iam_openid_connect_provider.github[0].arn : data.aws_iam_openid_connect_provider.github[0].arn
  repo_subs = [
    for repo in var.github_repos :
    "repo:${var.github_org}/${repo}:*"
  ]
}

data "aws_iam_policy_document" "github_actions_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = local.repo_subs
    }
  }
}


resource "aws_iam_role" "github_actions" {
  name               = var.role_name
  description        = "GitHub Actions OIDC role for Inspect Lens backend CI/CD"
  assume_role_policy = data.aws_iam_policy_document.github_actions_trust.json

  tags = merge(var.tags, {
    Name = var.role_name
  })
}

data "aws_iam_policy_document" "github_actions" {
  statement {
    sid       = "ECRAuth"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "ECRRepositoryPush"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
    ]

    resources = var.ecr_repository_arns
  }

  statement {
    sid    = "SSMDeploy"
    effect = "Allow"

    actions = [
      "ssm:SendCommand",
      "ssm:GetCommandInvocation",
      "ssm:ListCommandInvocations",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "github_actions" {
  name   = "InspectLensGitHubActionsCDPolicy"
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.github_actions.json
}