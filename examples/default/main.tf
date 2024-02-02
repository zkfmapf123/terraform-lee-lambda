provider "aws" {
  profile = "default"
  region  = "ap-northeast-2"
}

module "lambda" {
  source = "../../"

  provider_config = {
    profile = "default"
    region  = "ap-northeast-2"
  }

  lambda_source_code = base64encode("./function.zip")

  lambda_config = {
    iam_name = "Basic-Lambda-Role"
    filename = "function.zip"
    handler  = "index.handler"
    name     = "test-lambda"
  }

  lambda_hardware = {
    timeout     = "10"
    memory_size = "128"
    runtime     = "nodejs18.x"
  }

  env_vars = {
    testA : 10
    testB : 20
  }

  tags = {
  }
}
