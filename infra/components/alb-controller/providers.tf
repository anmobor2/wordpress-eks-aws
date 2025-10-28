terraform {
  backend "s3" {}  # usa backend.hcl o CLI para la config
  required_providers {
    aws = { source = "hashicorp/aws",  version = ">= 5.0" }
    helm = { source = "hashicorp/helm", version = ">= 2.11" }
  }
}

provider "aws" { region = var.region }

# Descubre el cluster por nombre (no dependes del componente EKS en el mismo plan)
data "aws_eks_cluster" "this" {
  name = var.cluster_name
}
data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks","get-token","--cluster-name", var.cluster_name]
    }
  }
}