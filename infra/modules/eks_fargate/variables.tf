variable "cluster_name"        { type = string }
variable "vpc_id"              { type = string }
variable "private_subnet_ids"  { type = list(string) }
variable "tags"                { type = map(string) default = {} }
variable "kubernetes_version"  { type = string default = "1.30" }
# Namespace que corre en Fargate (WordPress)
variable "fargate_namespace"   { type = string default = "wordpress" }