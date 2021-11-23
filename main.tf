locals {
  k8s_role_create          = length(var.k8s_role_arn) == 0 ? true : false
  k8s_irsa_role_create     = var.enabled && var.k8s_rbac_create && var.k8s_service_account_create && local.k8s_role_create
  k8s_service_account_name = "${var.helm_chart_name}-${var.helm_release_name}"

  values_default = yamlencode({
    "image" : {
      "tag" : var.grafana_release
    }
    "replicas" : var.grafana_replicas
    "admin" : {
      "existingSecret" : "grafana-secrets"
    }
    "extraSecretMounts" : [{
      "name" : "grafana-secrets-mount"
      "secretName" : "grafana-secrets"
      "defaultMode" : "0440"
      "mountPath" : "/etc/secrets/auth_generic_oauth"
      "readOnly" : "true"
    }]
    "grafana.ini" : {
      "security" : {
        "admin_user" : "admin"
        "admin_password" : "$__file{/etc/secrets/auth_generic_oauth/admin-password}"
      }
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

resource "helm_release" "self" {
  count            = var.enabled && !var.argo_application_enabled ? 1 : 0
  repository       = var.helm_repo_url
  chart            = var.helm_chart_name
  version          = var.helm_chart_version
  create_namespace = var.helm_create_namespace
  namespace        = var.k8s_namespace
  name             = var.helm_release_name

  values = [
    data.utils_deep_merge_yaml.values[0].output
  ]

  dynamic "set" {
    for_each = var.settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
