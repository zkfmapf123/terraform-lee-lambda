locals {
  config = yamldecode(file(var.input_path)).lambda

  iam       = local.config.iam
  computing = local.config.computing

  computing_envs = merge(local.computing.environments...)

}

