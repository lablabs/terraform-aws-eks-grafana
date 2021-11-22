locals {
  argo_application_values = {
    "project" : var.argo_project
    "source" : {
      "repoURL" : var.helm_repo_url
      "chart" : var.helm_chart_name
      "targetRevision" : var.helm_chart_version
      "helm" : {
        "releaseName" : var.helm_release_name
        "parameters" : [for k, v in var.settings : tomap({ "forceString" : true, "name" : k, "value" : v })]
        "values" : try(data.utils_deep_merge_yaml.values[0].output, {})
      }
    }
    "destination" : {
      "server" : var.argo_destionation_server
      "namespace" : var.k8s_namespace
    }
    "syncPolicy" : var.argo_sync_policy
    "info" : var.argo_info
  }

  repo_credentials_ssh = {
    "url" : var.grafana_dashboards_repo
    "sshPrivateKey" : var.grafana_dashboards_repo_sshkey
  }
  repo_credentials_token = {
    "url" : var.grafana_dashboards_repo
    "username" : var.grafana_dashboards_repo_username
    "password" : var.grafana_dashboards_repo_token
  }
}

data "utils_deep_merge_yaml" "argo_application_values" {
  count = var.enabled && var.argo_application_enabled && var.argo_application_use_helm ? 1 : 0
  input = compact([
    yamlencode(local.argo_application_values),
    var.argo_application_values
  ])
}

resource "helm_release" "argocd_application" {
  count = var.enabled && var.argo_application_enabled && var.argo_application_use_helm ? 1 : 0

  chart     = "${path.module}/helm/argocd-application"
  name      = var.helm_release_name
  namespace = var.argo_namespace

  values = [
    data.utils_deep_merge_yaml.argo_application_values[0].output
  ]
}


resource "kubernetes_manifest" "grafana" {
  count = var.enabled && var.argo_application_enabled && !var.argo_application_use_helm ? 1 : 0
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind"       = "Application"
    "metadata" = {
      "name"      = var.helm_release_name
      "namespace" = var.argo_namespace
    }
    "spec" = local.argo_application_values
  }
}

resource "kubernetes_manifest" "dashboards" {
  count = var.enabled && var.argo_application_enabled && var.grafana_dashboards ? 1 : 0
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind"       = "Application"
    "metadata" = {
      "name"      = "${var.helm_release_name}-dashboards"
      "namespace" = var.argo_namespace
    }
    "spec" = {
      "project" = var.argo_project
      "source" = {
        "repoURL" = var.grafana_dashboards_repo
        "targetRevision" = var.grafana_dashboards_repo_revision
        "path" = var.grafana_dashboards_repo_path
      }
      "destination" = {
        "server" = var.argo_destionation_server
        "namespace" = var.k8s_namespace
      }
      "syncPolicy" = var.argo_sync_policy
      "info" = var.argo_info
    }
  }
}

resource "kubernetes_secret" "dashboards_repo" {
  count = var.enabled && var.argo_application_enabled && var.grafana_dashboards ? 1 : 0
  metadata {
    name      = "${var.helm_release_name}-dashboards"
    namespace = var.argo_namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }
   data = var.grafana_dashboards_repo_sshkey != null ? local.repo_credentials_ssh : local.repo_credentials_token
}