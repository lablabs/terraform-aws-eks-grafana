resource "kubernetes_namespace" "grafana" {
  count = var.enabled && var.helm_create_namespace ? 1 : 0
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

resource "kubernetes_secret" "admin_login" {
  count = var.enabled ? 1 : 0
  type  = "Opaque"
  metadata {
    name      = "${var.helm_chart_name}-${var.helm_release_name}-admin-login"
    namespace = var.k8s_namespace
  }
  data = {
    "admin-user"     = var.grafana_admin_user
    "admin-password" = random_password.admin_password[0].result
  }
}
