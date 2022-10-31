output "helm_release_metadata" {
  description = "Helm release attributes"
  value       = try(helm_release.this[0].metadata, {})
}

output "helm_release_application_metadata" {
  description = "Argo application helm release attributes"
  value       = try(helm_release.argo_application[0].metadata, {})
}

output "kubernetes_application_attributes" {
  description = "Argo kubernetes manifest attributes"
  value       = try(kubernetes_manifest.this[0], {})
}

output "iam_role_attributes" {
  description = "Grafana IAM role attributes"
  value       = try(aws_iam_role.this[0], {})
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
