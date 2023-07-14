terraform {

  backend "s3" {
    bucket = "sprutton1-taskly-state"
    key    = "taslky/tfstate"
    region = "us-east-1"
  }

  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.7"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
  }
}
