###############################################################################
# IAM User
###############################################################################

resource "aws_iam_user" "this" {

  name = var.iam_user_name

  tags = merge(
    var.tags,
    {
      Name = var.iam_user_name
    }
  )
}

###############################################################################
# IAM Group
###############################################################################

resource "aws_iam_group" "this" {

  name = var.iam_group_name
}

###############################################################################
# Attach Policies to IAM Group
###############################################################################

resource "aws_iam_group_policy_attachment" "this" {

  count = length(var.policy_arns)

  group      = aws_iam_group.this.name
  policy_arn = var.policy_arns[count.index]
}

###############################################################################
# Add IAM User to IAM Group
###############################################################################

resource "aws_iam_user_group_membership" "this" {

  user = aws_iam_user.this.name

  groups = [
    aws_iam_group.this.name
  ]
}