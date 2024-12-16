provider "aws" {
  profile = "zent-dev"
  region  = "ap-northeast-2"
}

module "go-lambda" {
  source = "../../"

  auto_deploy = {
    is_enable = true
    revision  = "1.0.0"
  }

  common_attr = {
    name = "test-node-lambda"
  }

  iam_attr = {
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "AllowLambdaAccessECSTag",
          "Effect" : "Allow",
          "Action" : [
            "ecs:TagResource"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "AllowLambdaAccessEC2",
          "Effect" : "Allow",
          "Action" : [
            "ec2:*"
          ],
          "Resource" : "*"
      }]
    })
  }

  ecr_attr = {
    exists_ecr_registry = "767397666569.dkr.ecr.ap-northeast-2.amazonaws.com/lambda-test-functions"
  }

  compute_attr = {
    timeout      = 10
    memory       = 128
    architecture = "arm64"
    environments = {
      REGION = "ap-northeast-2"
      NAME   = "leedonggyu"
    }
    logging_format = "JSON"
  }

  network_attr = {
    vpc_id     = null
    subnet_ids = []
    sg_ids     = []
  }
}

output "v" {
  value = module.go-lambda
}
