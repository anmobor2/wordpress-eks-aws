output "cluster_name" {
  value       = module.eks.cluster_name
  description = "EKS cluster name"
}

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "API server endpoint"
}

output "cluster_oidc_provider_arn" {
  value       = module.eks.oidc_provider_arn
  description = "OIDC provider ARN for IRSA"
}

output "cluster_certificate_authority_data" {
  value       = module.eks.cluster_certificate_authority_data
  description = "Cluster CA (base64)"
}

output "private_subnet_ids" {
  value       = var.private_subnet_ids
  description = "Private subnets used by the cluster"
}

output "efs_csi_irsa_role_arn" {
  value       = module.irsa_efs_csi.iam_role_arn
  description = "IAM role ARN usado por el EFS CSI addon"
}