# argocd

variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled"
}

variable "cluster_identity_oidc_issuer" {
  type        = string
  description = "The OIDC Identity issuer for the cluster"
}

variable "cluster_identity_oidc_issuer_arn" {
  type        = string
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account"
}

# Helm

variable "helm_create_namespace" {
  type        = bool
  default     = true
  description = "Create the namespace if it does not yet exist"
}

variable "helm_chart_name" {
  type        = string
  default     = "grafana"
  description = "Helm chart name to be installed"
}

variable "helm_chart_version" {
  type        = string
  default     = "6.17.6"
  description = "Version of the Helm chart"
}

variable "helm_release_name" {
  type        = string
  default     = "grafana"
  description = "Helm release name"
}

variable "helm_repo_url" {
  type        = string
  default     = "https://grafana.github.io/helm-charts"
  description = "Helm repository"
}

# K8s

variable "k8s_namespace" {
  type        = string
  default     = "grafana"
  description = "The K8s namespace in which the ingress-nginx has been created"
}

variable "k8s_rbac_create" {
  type        = bool
  default     = true
  description = "Whether to create and use RBAC resources"
}

variable "k8s_service_account_create" {
  type        = bool
  default     = true
  description = "Whether to create Service Account"
}

variable "k8s_irsa_role_name_prefix" {
  type        = string
  default     = "grafana-irsa"
  description = "The IRSA role name prefix for grafana"
}

variable "k8s_irsa_additional_policies" {
  type        = map(string)
  default     = {}
  description = "Map of the additional policies to be attached to default role. Where key is arbiraty id and value is policy arn."
}

variable "k8s_role_arn" {
  type        = string
  default     = ""
  description = "Whether to create and use default role or use existing role. Useful for a variety of use cases, such as cross account access. Default (empty string) use default generted role."
}

variable "settings" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://artifacthub.io/packages/helm/argo/argo-cd"
}

variable "values" {
  type        = string
  default     = ""
  description = "Additional yaml encoded values which will be passed to the Helm chart."
}

variable "grafana_release" {
  type        = string
  default     = "8.2.3"
  description = "Grafana release version"
}

variable "grafana_admin_user" {
  type        = string
  default     = "admin"
  description = "Grafana Admin user name"
}

variable "argo_application_enabled" {
  type        = bool
  default     = false
  description = "If set to true, the module will be deployed as ArgoCD application, otherwise it will be deployed as a Helm release"
}

variable "argo_application_use_helm" {
  type        = bool
  default     = false
  description = "If set to true, the ArgoCD Application manifest will be deployed using Kubernetes provider as a Helm release. Otherwise it'll be deployed as a Kubernetes manifest. See Readme for more info"
}

variable "argo_application_values" {
  type        = string
  default     = ""
  description = "Value overrides to use when deploying argo application object with helm"
}

variable "argo_destionation_server" {
  type        = string
  default     = "https://kubernetes.default.svc"
  description = "Destination server for ArgoCD Application"
}

variable "argo_project" {
  type        = string
  default     = "default"
  description = "ArgoCD Application project"
}

variable "argo_info" {
  type = list(object({
    name  = string
    value = string
  }))
  default = [{
    "name"  = "terraform"
    "value" = "true"
  }]
  description = "ArgoCD info manifest parameter"
}

variable "argo_sync_policy" {
  type        = any
  description = "ArgoCD syncPolicy manifest parameter"
  default     = {}
}

variable "argo_namespace" {
  type        = string
  default     = "argo"
  description = "Namespace to deploy ArgoCD application CRD to"
}

variable "argo_kubernetes_manifest_field_manager_name" {
  type        = string
  default     = "Terraform"
  description = "The name of the field manager to use when applying the kubernetes manifest resource. Defaults to Terraform"
}

variable "argo_kubernetes_manifest_field_manager_force_conflicts" {
  type        = bool
  default     = false
  description = "Forcibly override any field manager conflicts when applying the kubernetes manifest resource"
}
