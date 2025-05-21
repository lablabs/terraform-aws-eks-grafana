output "helm_release_metadata" {
  description = "Helm release attributes"
  value       = try(module.addon.helm_release_metadata, {})
}

output "helm_release_application_metadata" {
  description = "Argo application helm release attributes"
  value       = try(module.addon.helm_release_application_metadata, {})
}

output "kubernetes_application_attributes" {
  description = "Argo kubernetes manifest attributes"
  value       = try(module.addon.kubernetes_application_attributes, {})
}

output "iam_role_attributes" {
  description = "Grafana IAM role attributes"
  value       = try(module.addon-irsa.iam_role_attributes, {})
}

output "grafana_admin_user" {
  description = "Grafana admin user"
  value       = var.grafana_admin_user
}

output "grafana_admin_password" {
  description = "Grafana admin user password"
  value       = var.grafana_admin_password != null ? var.grafana_admin_password : random_password.admin_password[0].result
  sensitive   = true
}
