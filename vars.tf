variable "provider_config" {
  description = "provider_config"

  type = object({
    profile = string
    region  = string
  })

  default = {
    profile = "default"
    region  = "ap-northeast-2"
  }
}

variable "lambda_source_code" {
  type = string
}

variable "lambda_config" {
  type = object({
    iam_name = string
    filename = string
    handler  = string
    name     = string
  })

  default = {
    iam_name = ""
    filename = "function.zip"
    handler  = "handler.go"
    name     = "function-name"
  }
}

variable "lambda_hardware" {
  type = object({
    timeout     = string
    memory_size = string
    runtime     = string
  })

  default = {
    timeout     = "10"
    memory_size = "128"
    runtime     = "nodejs18.x"
  }
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "env_vars" {
  type = map(any)
}
