variable "region" {
  description = "AWS region for the cluster"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EKS will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS/Fargate"
  type        = list(string)
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}