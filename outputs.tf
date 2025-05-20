output "grafana_admin_user" {
  description = "Grafana admin user"
  value       = var.grafana_admin_user
}

output "grafana_admin_password" {
  description = "Grafana admin user password"
  value       = var.grafana_admin_password != null ? var.grafana_admin_password : random_password.admin_password[0].result
  sensitive   = true
}
