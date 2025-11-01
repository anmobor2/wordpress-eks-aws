# ================================
# ALB Controller Component
# ================================

locals {
  tags = merge({
    Project   = "wordpress-eks-aws"
    Component = "alb-controller"
  }, var.tags)
}

# -----------------------------
# Datos del cluster EKS existente
# -----------------------------
data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

# Construcción del ARN del proveedor OIDC (a partir de la URL del cluster)
locals {
  oidc_url      = data.aws_eks_cluster.this.identity[0].oidc[0].issuer               # https://oidc.eks.../id/XXXX
  oidc_hostpath = replace(local.oidc_url, "https://", "")                             # oidc.eks.../id/XXXX
  oidc_arn      = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_hostpath}"
}

# -----------------------------
# Módulo Load Balancer Controller
# -----------------------------
module "lb_controller" {
  source            = "../../modules/lb_controller"
  cluster_name      = var.cluster_name
  oidc_provider_arn = local.oidc_arn
  tags              = local.tags
}

