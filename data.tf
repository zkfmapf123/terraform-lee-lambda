data "aws_iam_role" "iam_lambda" {
  name = lookup(var.lambda_config, "iam_name")
}
