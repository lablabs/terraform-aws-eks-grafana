resource "kubernetes_namespace" "monitoring" {
  count = var.enabled ? 1 : 0
  metadata {
    name = var.k8s_namespace
  }
}

resource "random_password" "admin_password" {
  count   = var.enabled ? 1 : 0
  length  = 32
  upper   = true
  special = false
}

resource "kubernetes_secret" "grafana_secrets" {
  count = var.enabled ? 1 : 0
  type  = "Opaque"
  metadata {
    name      = "grafana-secrets"
    namespace = var.k8s_namespace
  }
  data = {
    "admin-user"     = var.grafana_admin_user
    "admin-password" = random_password.admin_password[0].result
  }
}

data "aws_secretsmanager_secret" "dashboards_repo" {
  count = var.grafana_dashboards_repo_secret != null ? 1 : 0
  name  = "grafana_dashboards_repo_secret"
}
data "aws_secretsmanager_secret_version" "dashboards_repo" {
  count     = var.grafana_dashboards_repo_secret != null ? 1 : 0
  secret_id = data.aws_secretsmanager_secret.dashboards_repo[0].id
}

output "grafana_dashboards_repo_secret" {
  value       = var.grafana_dashboards_repo_secret != null ? jsondecode(data.aws_secretsmanager_secret_version.dashboards_repo[0].secret_string)[var.grafana_dashboards_repo_secret] : "no_secret"
  sensitive   = true
  description = "Secret to Grafana Dashboards repository"
}

data "aws_secretsmanager_secret" "database" {
  count = var.grafana_database_secret != null ? 1 : 0
  name  = "grafana_database_secret"
}

data "aws_secretsmanager_secret_version" "database" {
  count     = var.grafana_database_secret != null ? 1 : 0
  secret_id = data.aws_secretsmanager_secret.database[0].id
}

output "grafana_database_secret" {
  value       = var.grafana_database_secret != null ? jsondecode(data.aws_secretsmanager_secret_version.database[0].secret_string)[var.grafana_database_secret] : "no_secret"
  sensitive   = true
  description = "Secret to Grafana Database"
}
