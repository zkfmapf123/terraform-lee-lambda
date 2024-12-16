################################################# Data #################################################
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "random_string" "random" {

  length  = 7
  special = false

  keepers = {
    always_generate = "${timestamp()}"
  }
}

resource "null_resource" "build" {
  count = var.auto_deploy.is_enable ? 1 : 0

  provisioner "local-exec" {
    command = <<EOT

    ## Public Registry
    aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws

    ## Private Registry
    ACCOUNT_ID=${data.aws_caller_identity.current.account_id}
    REGION=${data.aws_region.current.name}
    IMAGE=${var.ecr_attr.exists_ecr_registry}
    REVISION=${var.auto_deploy.revision}

    aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com
    docker build -t $IMAGE .

    docker tag $IMAGE $IMAGE:$REVISION
    docker push $IMAGE:$REVISION

    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}
