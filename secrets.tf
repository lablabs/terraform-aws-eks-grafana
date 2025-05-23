locals {
  grafana_admin_user_key     = "admin-user"
  grafana_admin_password_key = "admin-password" #pragma: allowlist secret
  grafana_namespace          = coalesce(var.namespace, try(local.addon.namespace, null), local.addon.name)
  grafana_secret_name        = coalesce(try(local.addon.helm_chart_name, null), local.addon.name)
}

resource "kubernetes_namespace_v1" "grafana" {
  count = var.enabled && coalesce(var.helm_create_namespace, true) ? 1 : 0

  metadata {
    name = local.grafana_namespace
  }
}

resource "random_password" "admin_password" {
  count = var.enabled && var.grafana_admin_password == null ? 1 : 0

  length  = 32
  upper   = true
  special = false
}

resource "kubernetes_secret_v1" "admin_login" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = "${local.grafana_secret_name}-admin-login"
    namespace = var.namespace
  }

  data = {
    (local.grafana_admin_user_key)     = var.grafana_admin_user
    (local.grafana_admin_password_key) = var.grafana_admin_password != null ? var.grafana_admin_password : random_password.admin_password[0].result
  }

  type = "Opaque"

  depends_on = [
    kubernetes_namespace_v1.grafana
  ]
}

provider "random" {
}
