locals {
  tags = merge(
    {
      Project     = "wordpress-eks-aws"
      Component   = "eks-fargate"
      Environment = replace(var.cluster_name, "/^(.*)-(dev|prod)$/", "$2")
      ManagedBy   = "terraform"
    },
    var.tags
  )
}

module "eks" {
  source  = "../../modules/eks_fargate"

  cluster_name       = var.cluster_name
  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids

  # Pasa etiquetas comunes al módulo
  tags = local.tags
}

# IRSA para EFS CSI (usa el OIDC del cluster)
module "irsa_efs_csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.30"

  role_name = "${var.cluster_name}-irsa-efs-csi"
  attach_efs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn = module.eks.oidc_provider_arn
      # El addon crea este SA en kube-system
      namespace_service_accounts = ["kube-system:efs-csi-controller-sa"]
    }
  }

  tags = local.tags
}

# Addon gestionado EFS CSI (recomendado en EKS)
resource "aws_eks_addon" "efs_csi" {
  cluster_name = module.eks.cluster_name
  addon_name   = "aws-efs-csi-driver"

  # Vincula la IRSA del controlador
  service_account_role_arn = module.irsa_efs_csi.iam_role_arn

  # Para evitar bloqueos en upgrades
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = local.tags
}