################################################# Data #################################################
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_ecr_repository" "ecr" {
  name = lookup(local.computing, "image_url")
}

################################################# ECR #################################################
## ECR Repository 없을 때 생성
resource "aws_ecr_repository" "ecr_repository" {
  count = data.aws_ecr_repository.ecr.arn == "" ? 1 : 0
  name  = lookup(local.computing, "image_url")
}

resource "aws_ecr_lifecycle_policy" "ecr_repository_lifecycle" {
  count = data.aws_ecr_repository.ecr.arn == "" ? 1 : 0

  repository = aws_ecr_repository.ecr_repository[0].name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 20 images",
            "selection": {
                "tagStatus": "tagged",
                "countType": "imageCountMoreThan",
                "countNumber": 20
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

################################################# Lambda #################################################
resource "aws_lambda_function" "function" {
  function_name = lookup(local.computing, "name")
  image_uri     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${local.computing.image_url}:${random_string.random.id}"
  package_type  = "Image"

  timeout     = tonumber(lookup(local.computing, "timeout"))
  memory_size = tonumber(lookup(local.computing, "memory"))
  role        = aws_iam_role.lambda_role.arn

  architectures = [lookup(local.computing, "architecture")]

  ## environment 
  environment {
    variables = merge(lookup(local.computing, "environments")...)
  }

  ## tags
  tags = merge(lookup(local.computing, "tags")...)

  depends_on = [null_resource.build]
}

output "build_number" {
  value = "${local.computing.image_url}:${random_string.random.id}"
}
