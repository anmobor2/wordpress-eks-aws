variable "cluster_name"       { type = string }
variable "oidc_provider_arn"  { type = string }
variable "namespace"          { type = string default = "kube-system" }
variable "service_account"    { type = string default = "aws-load-balancer-controller" }
variable "tags"               { type = map(string) default = {} }