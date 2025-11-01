locals { tags = merge({ ManagedBy = "terraform" }, var.tags) }

resource "aws_security_group" "efs" {
  name        = "${var.name}-efs"
  description = "Allow NFS from VPC"
  vpc_id      = var.vpc_id
  ingress { from_port = 2049 to_port = 2049 protocol = "tcp" cidr_blocks = [var.vpc_cidr_block] }
  egress  { from_port = 0    to_port = 0    protocol = "-1"  cidr_blocks = ["0.0.0.0/0"] }
  tags = local.tags
}

resource "aws_efs_file_system" "this" {
  creation_token  = var.name
  performance_mode = "generalPurpose"
  throughput_mode  = "elastic"
  lifecycle_policy { transition_to_ia = "AFTER_30_DAYS" }
  tags = local.tags
}

resource "aws_efs_mount_target" "mt" {
  for_each       = toset(var.subnet_ids)
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = each.value
  security_groups = [aws_security_group.efs.id]
}