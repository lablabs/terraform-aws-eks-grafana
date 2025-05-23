/**
 * # AWS EKS Grafana Terraform module
 *
 * A Terraform module to deploy the [Grafana](https://grafana.com/) on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-grafana/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-grafana/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-grafana/actions/workflows/pre-commit.yml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-grafana/actions/workflows/pre-commit.yml)
 */

locals {
  addon = {
    name = "grafana"

    helm_chart_version = "6.43.5"
    helm_repo_url      = "https://grafana.github.io/helm-charts"
  }

  addon_irsa = {
    (local.addon.name) = {
    }
  }

  addon_values = yamlencode({
    rbac = {
      create = module.addon-irsa[local.addon.name].rbac_create
    }

    serviceAccount = {
      create = module.addon-irsa[local.addon.name].service_account_create
      name   = module.addon-irsa[local.addon.name].service_account_name
      annotations = module.addon-irsa[local.addon.name].irsa_role_enabled ? {
        "eks.amazonaws.com/role-arn" = module.addon-irsa[local.addon.name].iam_role_attributes.arn
      } : tomap({})
    }

    admin = {
      existingSecret = kubernetes_secret_v1.admin_login[0].metadata[0].name
      userKey        = local.grafana_admin_user_key
      passwordKey    = local.grafana_admin_password_key
    }
  })

  addon_depends_on = []
}
