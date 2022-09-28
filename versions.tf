terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.19"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.11"
    }
    utils = {
      source  = "cloudposse/utils"
      version = ">= 0.17.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}
