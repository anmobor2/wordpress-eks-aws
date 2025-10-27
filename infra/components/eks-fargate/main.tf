terraform { required_version = ">= 1.6.0" }


provider "aws" { region = var.region }


variable "region" { type = string }
variable "cluster_name" { type = string }
variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }


module "eks" {
source = "../../modules/eks_fargate"
cluster_name = var.cluster_name
vpc_id = var.vpc_id
private_subnet_ids = var.private_subnet_ids
}


module "lb_controller" {
source = "../../modules/lb_controller"
cluster_name = module.eks.cluster_name
oidc_provider_arn = module.eks.oidc_provider_arn
}


module "efs_csi" { source = "../../modules/efs_csi_addon" cluster_name = module.eks.cluster_name }


output "cluster_name" { value = module.eks.cluster_name }