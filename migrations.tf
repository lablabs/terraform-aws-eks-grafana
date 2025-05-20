
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
  from = kubernetes_job.helm_argo_application_wait
  to   = module.addon.kubernetes_job.helm_argo_application_wait
}

moved {
  from = aws_iam_role_policy_attachment.this_additional["AllowAssumeCloudWatchRole"]
  to   = module.addon-irsa["grafana"].aws_iam_role_policy_attachment.irsa_additional["AllowAssumeCloudWatchRole"]
}

moved {
  from = aws_iam_role.this[0]
  to   = module.addon-irsa["grafana"].aws_iam_role.irsa[0]
}
