output "helm_release_metadata" {
  description = "Helm release attributes"
  value       = try(helm_release.this[0].metadata, {})
}

output "helm_release_application_metadata" {
  description = "Argo application helm release attributes"
  value       = try(helm_release.argocd_application[0].metadata, {})
}

output "kubernetes_application_attributes" {
  description = "Argo kubernetes manifest attributes"
  value       = try(kubernetes_manifest.this[0], {})
}

output "iam_roles_attributes" {
  description = "Map of the IAM role atributes where key is component name"
  value       = try(aws_iam_role.this, {})
}
