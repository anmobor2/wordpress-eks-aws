# -----------------------------
# Outputs
# -----------------------------
output "irsa_role_arn" {
  value       = module.lb_controller.irsa_role_arn
  description = "IAM role ARN usado por el Load Balancer Controller"
}