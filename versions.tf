
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.6"
    }
    utils = {
      source  = "cloudposse/utils"
      version = ">= 0.14.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}
