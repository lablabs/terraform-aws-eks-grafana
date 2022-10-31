locals {
  values_default = yamlencode({
    rbac = {
      create = var.rbac_create
    }

    serviceAccount = merge(
      {
        create = var.service_account_create
        name   = var.service_account_name
      },
      local.irsa_role_create ? {
        annotations = {
          "eks.amazonaws.com/role-arn" = aws_iam_role.this[0].arn
        }
      } : {}
    )

    admin = {
      existingSecret = kubernetes_secret.admin_login[0].metadata[0].name
      userKey        = local.grafana_admin_user_key
      passwordKey    = local.grafana_admin_password_key
    }
  })
}

data "utils_deep_merge_yaml" "values" {
  count = var.enabled ? 1 : 0
  input = compact([
    local.values_default,
    var.values
  ])
}
