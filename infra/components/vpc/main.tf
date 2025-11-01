locals {
  tags = merge({
    Project   = "wordpress-eks-aws"
    Component = "vpc"
  }, var.tags)
}

module "vpc" {
  source    = "../../modules/vpc"
  name      = var.name
  cidr      = var.cidr
  az_count  = var.az_count
  tags      = local.tags
}