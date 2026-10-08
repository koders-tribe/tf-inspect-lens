# The user and group are optional (create_user): AWS free-plan organizations
# deny iam:CreateGroup via SCP, and the app can use the EC2 instance role.
# The app policy below is created either way.

resource "aws_iam_user" "this" {
  count = var.create_user ? 1 : 0

  name = var.iam_user_name

  tags = merge(var.tags, {
    Name = var.iam_user_name
  })
}

resource "aws_iam_group" "this" {
  count = var.create_user ? 1 : 0

  name = var.iam_group_name
}

resource "aws_iam_group_policy_attachment" "this" {
  count = var.create_user ? length(var.policy_arns) : 0

  group      = aws_iam_group.this[0].name
  policy_arn = var.policy_arns[count.index]
}

resource "aws_iam_user_group_membership" "this" {
  count = var.create_user ? 1 : 0

  user = aws_iam_user.this[0].name

  groups = [
    aws_iam_group.this[0].name
  ]
}

moved {
  from = aws_iam_user.this
  to   = aws_iam_user.this[0]
}

moved {
  from = aws_iam_group.this
  to   = aws_iam_group.this[0]
}

moved {
  from = aws_iam_user_group_membership.this
  to   = aws_iam_user_group_membership.this[0]
}

data "aws_iam_policy_document" "app" {
  # Must be known at plan time: a new bucket's ARN is not, so do not test it here.
  count = var.attach_app_policy ? 1 : 0

  statement {
    sid    = "S3ListBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    resources = [var.s3_bucket_arn]
  }

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
      "${var.s3_bucket_arn}/orgs/*",
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
  count = length(data.aws_iam_policy_document.app)

  # Named after iam_user_name even without a user, so existing policies keep
  # their name (renaming would replace them).
  name        = "${var.iam_user_name}-s3-ses"
  description = "Least-privilege S3 object access and SES send for Inspect Lens."
  policy      = data.aws_iam_policy_document.app[0].json
  tags        = var.tags
}

resource "aws_iam_group_policy_attachment" "app" {
  count = var.create_user ? length(aws_iam_policy.app) : 0

  group      = aws_iam_group.this[0].name
  policy_arn = aws_iam_policy.app[0].arn
}
