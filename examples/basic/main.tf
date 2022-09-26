module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.6.0"

  name               = "grafana-vpc"
  cidr               = "10.0.0.0/16"
  azs                = ["eu-central-1a", "eu-central-1b"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway = true
}

module "eks_cluster" {
  source  = "cloudposse/eks-cluster/aws"
  version = "0.43.2"

  region     = "eu-central-1"
  subnet_ids = module.vpc.public_subnets
  vpc_id     = module.vpc.vpc_id
  name       = "grafana"
}

module "eks_node_group" {
  source  = "cloudposse/eks-node-group/aws"
  version = "0.25.0"

  cluster_name   = "grafana"
  instance_types = ["t3.medium"]
  subnet_ids     = module.vpc.public_subnets
  min_size       = 1
  desired_size   = 1
  max_size       = 2
  depends_on     = [module.eks_cluster.kubernetes_config_map_id]
}

module "grafana" {
  source = "../../"

  enabled = true

  cluster_name                     = module.eks_cluster.eks_cluster_id
  cluster_identity_oidc_issuer     = data.aws_eks_cluster.shared.identity[0].oidc[0].issuer
  cluster_identity_oidc_issuer_arn = data.terraform_remote_state.shared.outputs.eks_cluster.eks.eks_cluster_identity_oidc_issuer_arn

  k8s_namespace = "monitoring"

  helm_repo_url      = "https://grafana.github.io/helm-charts"
  helm_chart_version = "6.17.6"
  helm_release_name  = "grafana"

  values = yamlencode({
    "persistence" : {
      "enabled" : true
    }
  })
}