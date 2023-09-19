terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.72"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1"
    }
  }

  # ##  Used for end-to-end testing on project; update to suit your needs
  backend "s3" {
    bucket         = "outchart-tf-state"
    key            = "outchart-tf-state/infra/eks/prod/tf.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "outchart-terraform-lock"
    encrypt        = true
  }
}
