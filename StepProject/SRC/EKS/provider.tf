# Here we must set our profile, otherwise infra will be created in the root account
provider "aws" {
  region  = var.region
  profile = var.iam_profile
}

provider "kubernetes" {
  host                   = aws_eks_cluster.agrynov.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.agrynov.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.agrynov.token
}

data "aws_availability_zones" "available" {}

# Not required: currently used in conjunction with using
# icanhazip.com to determine local workstation external IP
# to open EC2 Security Group access to the Kubernetes cluster.
# See workstation-external-ip.tf for additional information.
#provider "http" {}

#terraform {
#  required_version = ">= 0.13"
#
#  required_providers {
#    kubectl = {
#      source  = "gavinbunney/kubectl"
#      version = ">= 1.7.0"
#    }
#  }
#}

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.12.1"
    }
  }
}



provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.agrynov.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.agrynov.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.agrynov.token
  }
}


#provider "helm" {
#  host                   = aws_eks_cluster.agrynov.endpoint
#  cluster_ca_certificate = base64decode(aws_eks_cluster.agrynov.certificate_authority.0.data)
#  token                  = data.aws_eks_cluster_auth.agrynov.token
#}



