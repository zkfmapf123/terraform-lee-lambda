provider "aws" {
  profile = "dev"
  region  = "ap-northeast-2"
}

module "go-lambda" {
  source     = "../../"
  input_path = "./input.yaml"
}

output "v" {
  value = module.go-lambda
}
