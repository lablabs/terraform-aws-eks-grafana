locals {
  grafana_admin_user_key     = "admin-user"
  grafana_admin_password_key = "admin-password" #pragma: allowlist secret`
}

resource "kubernetes_namespace" "grafana" {
  count = var.enabled && var.helm_create_namespace ? 1 : 0

  metadata {
    name = var.namespace
  }
}

resource "random_password" "admin_password" {
  count = var.enabled && var.grafana_admin_password == null ? 1 : 0

  length  = 32
  upper   = true
  special = false
}

resource "kubernetes_secret" "admin_login" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = "${var.helm_release_name}-admin-login"
    namespace = var.namespace
  }

  data = {
    (local.grafana_admin_user_key)     = var.grafana_admin_user
    (local.grafana_admin_password_key) = var.grafana_admin_password != null ? var.grafana_admin_password : random_password.admin_password[0].result
  }

  type = "Opaque"

  depends_on = [
    kubernetes_namespace.grafana
  ]
}
