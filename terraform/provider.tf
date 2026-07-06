terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    bucket         = "quentonhorton-crc-tfstate"
    key            = "cloud-resume/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "cloud-resume-tflock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project   = "cloud-resume"
      ManagedBy = "terraform"
      Owner     = "qhorton"
    }
  }
}
