provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      Environment = var.environment
      Project     = "rate-currency-tracker"
      ProvisionedBy = "Terraform"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.12.0"
    }
  }

  backend "s3" {
    bucket         = "rate-currency-tracker-terraform-state"
    key            = "dev-rate-currency-tracker/terraform.tfstate"
    region         = "us-east-2"
  }

}

module "configuration" {
  source      = "../modules/services"
  environment = var.environment
  region      = var.region
  aws_account = var.aws_account
}


