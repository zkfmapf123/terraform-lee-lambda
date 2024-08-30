resource "random_string" "random" {

  length  = 7
  special = false

  keepers = {
    always_generate = "${timestamp()}"
  }
}

resource "null_resource" "build" {
  provisioner "local-exec" {
    command = <<EOT

    ACCOUNT_ID=${data.aws_caller_identity.current.account_id}
    REGION=${data.aws_region.current.name}
    IMAGE=${local.computing.image_url}:${random_string.random.id}

    aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com
    docker build -t $IMAGE .
    docker tag $IMAGE $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$IMAGE
    docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$IMAGE
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}
