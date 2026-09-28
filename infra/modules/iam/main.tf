resource "aws_iam_user" "this" {
  name = var.iam_user_name

  tags = merge(var.tags, {
    Name = var.iam_user_name
  })
}

resource "aws_iam_group" "this" {
  name = var.iam_group_name
}

resource "aws_iam_group_policy_attachment" "this" {
  count = length(var.policy_arns)

  group      = aws_iam_group.this.name
  policy_arn = var.policy_arns[count.index]
}

resource "aws_iam_user_group_membership" "this" {
  user = aws_iam_user.this.name

  groups = [
    aws_iam_group.this.name
  ]
}

data "aws_iam_policy_document" "app" {
  count = var.attach_app_policy && var.s3_bucket_arn != "" ? 1 : 0

  statement {
    sid    = "S3ObjectAccess"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:AbortMultipartUpload",
    ]
    resources = [
      "${var.s3_bucket_arn}/findings/*",
      "${var.s3_bucket_arn}/inspection-reports/*",
      "${var.s3_bucket_arn}/quotation-agreements/*",
    ]
  }

  dynamic "statement" {
    for_each = length(var.ses_identity_arns) > 0 ? [1] : []

    content {
      sid    = "SesSend"
      effect = "Allow"
      actions = [
        "ses:SendEmail",
        "ses:SendRawEmail",
      ]
      resources = var.ses_identity_arns
    }
  }
}

resource "aws_iam_policy" "app" {
  count = var.attach_app_policy && var.s3_bucket_arn != "" ? 1 : 0

  name        = "${var.iam_user_name}-s3-ses"
  description = "Least-privilege S3 object access and SES send for Inspect Lens."
  policy      = data.aws_iam_policy_document.app[0].json
  tags        = var.tags
}

resource "aws_iam_group_policy_attachment" "app" {
  count = var.attach_app_policy && var.s3_bucket_arn != "" ? 1 : 0

  group      = aws_iam_group.this.name
  policy_arn = aws_iam_policy.app[0].arn
}
