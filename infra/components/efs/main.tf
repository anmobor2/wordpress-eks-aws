locals {
  tags = merge({
    Project   = "wordpress-eks-aws"
    Component = "efs"
  }, var.tags)
}

# --- Traer VPC por remote_state (recomendado) ---
data "terraform_remote_state" "vpc" {
  count   = var.use_remote_state ? 1 : 0
  backend = "s3"
  config = {
    bucket = "tfstate-mycompany"    # <-- ajusta
    key    = "vpc/${terraform.workspace}.tfstate"
    region = var.region
  }
}

# Selección de valores: remote_state o vars directas
locals {
  vpc_id          = var.use_remote_state ? data.terraform_remote_state.vpc[0].outputs.vpc_id          : var.vpc_id
  private_subnets = var.use_remote_state ? data.terraform_remote_state.vpc[0].outputs.private_subnets : var.private_subnets
  vpc_cidr_block  = var.use_remote_state ? data.terraform_remote_state.vpc[0].outputs.vpc_cidr_block  : var.vpc_cidr_block
}

module "efs" {
  source          = "../../modules/efs"
  name            = var.name
  vpc_id          = local.vpc_id
  subnet_ids      = local.private_subnets
  vpc_cidr_block  = local.vpc_cidr_block
  tags            = local.tags
}