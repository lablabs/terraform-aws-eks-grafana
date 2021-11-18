resource "aws_iam_role_policy_attachment" "grafana" {
  for_each = toset(var.k8s_irsa_additional_policies)

  role       = aws_iam_role.grafana[0].name
  policy_arn = each.key
}

data "aws_iam_policy_document" "grafana_irsa" {
  count = local.k8s_irsa_role_create ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_identity_oidc_issuer_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.k8s_namespace}:${local.k8s_service_account_name}",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "grafana" {
  count = local.k8s_irsa_role_create ? 1 : 0

  name               = "${var.k8s_irsa_role_name_prefix}-${var.helm_chart_name}"
  assume_role_policy = data.aws_iam_policy_document.grafana_irsa[0].json
}