resource "random_password" "admin_password" {
  count = var.enabled ? 1 : 0
  length           = 32
  upper            = true
  special          = false

}

resource "random_password" "grafana_db_pwd" {
  count = var.enabled ? 1 : 0
  length           = 32
  upper            = true
  special          = false
}

resource "kubernetes_secret" "grafana_secrets" {
  count = var.enabled ? 1 : 0
  type = "Opaque"
  metadata {
    name      = "grafana-secrets"
    namespace = var.k8s_namespace
  }
  data = {
    "admin-user"        = var.grafana_admin_user
    "admin-password"    = random_password.admin_password[0].result
    "grafana_db_admin"  = var.grafana_admin_user
    "grafana_db_pwd"    = random_password.grafana_db_pwd[0].result
  }
}