locals {
  tags = merge({
    ManagedBy = "terraform"
  }, var.tags)
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  # Solo Fargate (sin node groups EC2)
  eks_managed_node_groups = {}
  self_managed_node_groups = {}
  fargate_profiles = {
    wp = {
      name       = "wp"
      selectors  = [{ namespace = var.fargate_namespace }]
      subnet_ids = var.private_subnet_ids
    }
  }

  enable_cluster_log_types = ["api","audit","authenticator","controllerManager","scheduler"]
  tags = local.tags
}