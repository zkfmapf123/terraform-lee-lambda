######################################## IAM ########################################
data "aws_iam_policy_document" "lambda_default_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = lookup(local.iam, "name")
  assume_role_policy = data.aws_iam_policy_document.lambda_default_policy_document.json
}

resource "aws_iam_policy" "lambda_policy" {
  policy = jsonencode({
    "Version" : "2012-10-17"
    "Statement" : lookup(local.iam, "policy")
  })
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
