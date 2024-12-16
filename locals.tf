locals {
  tags = {
    Name        = "${var.common_attr.name}-function"
    Revision    = var.auto_deploy.revision
    System      = "Lambda"
    ecrRegistry = lookup(var.ecr_attr, "exists_ecr_registry")
    vpcId       = lookup(var.network_attr, "vpc_id")
  }
}