################################################ Lambda #################################################
resource "aws_lambda_function" "function" {
  function_name = "${var.common_attr.name}-function"
  image_uri     = "${var.ecr_attr.exists_ecr_registry}:${var.auto_deploy.revision}"

  package_type = "Image"

  timeout     = tonumber(lookup(var.compute_attr, "timeout"))
  memory_size = tonumber(lookup(var.compute_attr, "memory"))
  role        = aws_iam_role.lambda_role.arn

  architectures = [lookup(var.compute_attr, "architecture")]

  logging_config {
    log_format = "JSON"
  }

  ## vpc config
  vpc_config {
    vpc_id             = lookup(var.network_attr, "vpc_id")
    subnet_ids         = lookup(var.network_attr, "subnet_ids")
    security_group_ids = lookup(var.network_attr, "sg_ids")
  }

  ## environment 
  environment {
    variables = var.compute_attr.environments
  }

  # tags
  tags = local.tags

  depends_on = [null_resource.build]
}
