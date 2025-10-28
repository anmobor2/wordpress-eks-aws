locals {
  tags = merge({ ManagedBy = "terraform" }, var.tags)
}

module "irsa_alb" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.30"

  role_name = "${var.cluster_name}-alb-controller"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn = var.oidc_provider_arn
      namespace_service_accounts = ["${var.namespace}:${var.service_account}"]
    }
  }

  tags = local.tags
}

resource "helm_release" "alb" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = var.namespace
  create_namespace = false

  # Deja que el chart cree el SA con la anotación de IRSA
  set { name = "clusterName"               value = var.cluster_name }
  set { name = "serviceAccount.create"     value = "true" }
  set { name = "serviceAccount.name"       value = var.service_account }
  set { name = "region"                    value = "" } # opcional; autodetecta
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.irsa_alb.iam_role_arn
  }
}