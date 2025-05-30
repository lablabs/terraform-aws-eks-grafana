
moved {
  from = kubernetes_manifest.this
  to   = module.addon.kubernetes_manifest.this
}

moved {
  from = helm_release.this
  to   = module.addon.helm_release.this
}

moved {
  from = helm_release.argo_application
  to   = module.addon.helm_release.argo_application
}

moved {
  from = aws_iam_role.this[0]
  to   = module.addon-irsa["grafana"].aws_iam_role.irsa[0]
}

moved {
  from = aws_iam_role_policy_attachment.this[0]
  to   = module.addon-irsa["grafana"].aws_iam_role_policy_attachment.this[0]
}

moved {
  from = aws_iam_policy.this[0]
  to   = module.addon-irsa["grafana"].aws_iam_policy.this[0]
}

moved {
  from = aws_iam_role_policy_attachment.this_additional
  to   = module.addon-irsa["tempo"].aws_iam_role_policy_attachment.this_additional
}
