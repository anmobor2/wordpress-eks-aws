locals {
  tags = merge({
    Project   = "wordpress-eks-aws"
    Component = "alb-controller"
  }, var.tags)
}

module "lb_controller" {
  source            = "../../modules/lb_controller"
  cluster_name      = var.cluster_name
  oidc_provider_arn = data.aws_eks_cluster.this.identity[0].oidc[0].issuer_arn
  tags              = local.tags
}