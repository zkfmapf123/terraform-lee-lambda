variable "auto_deploy" {
  description = "배포 옵션입니다."

  default = {
    is_enable = false
    revision  = "1.0.0"
  }
}

variable "common_attr" {
  description = "공통 옵션입니다."

  default = {
    name = ""
  }
}

variable "iam_attr" {
  description = "iam 옵션입니다."

  default = {
    policy = {}
  }

}

variable "ecr_attr" {
  description = "ecr 옵션입니다."

  default = {
    exists_ecr_registry = "" ## false 일 경우 (required)
  }

  validation {
    condition     = var.ecr_attr.exists_ecr_registry != ""
    error_message = "'exists_ecr_registry' must not be empty."
  }
}

variable "compute_attr" {
  description = "lambda computing 옵션입니다."

  default = {
    timeout        = 10
    memory         = 128
    architecture   = "arm64" ## x86 | arm64
    logging_format = "JSON"  ## Text | JSON
    environments = {
      System = "lambda"
    }
  }
}

variable "network_attr" {
  description = "lambda computing에 network 옵션입니다."

  default = {
    vpc_id     = null
    subnet_ids = []
    sg_ids     = []
  }
}