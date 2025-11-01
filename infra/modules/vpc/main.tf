locals { tags = merge({ ManagedBy = "terraform" }, var.tags) }

data "aws_availability_zones" "available" { state = "available" }

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.name
  cidr = var.cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  private_subnets = [for i in range(var.az_count) : cidrsubnet(var.cidr, 8, i)]
  public_subnets  = [for i in range(var.az_count) : cidrsubnet(var.cidr, 8, i + 100)]

  enable_nat_gateway = var.enable_nat
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.tags
}