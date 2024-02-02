resource "aws_lambda_function" "test_lambda" {
  filename         = lookup(var.lambda_config, "filename")
  function_name    = lookup(var.lambda_config, "name")
  role             = data.aws_iam_role.iam_lambda.arn
  handler          = lookup(var.lambda_config, "handler")
  source_code_hash = var.lambda_source_code

  ## config
  timeout     = tonumber(lookup(var.lambda_hardware, "timeout"))
  memory_size = tonumber(lookup(var.lambda_hardware, "memory_size"))
  runtime     = lookup(var.lambda_hardware, "runtime")

  ## environment
  dynamic "environment" {
    for_each = length(var.env_vars) == 0 ? [] : [1]

    content {
      variables = var.env_vars
    }
  }

  tags = merge({
    "Property" : "Lambda",
    "Name" : lookup(var.lambda_config, "name")
  }, var.tags)

  lifecycle {
    ignore_changes = [source_code_hash]
  }
}
