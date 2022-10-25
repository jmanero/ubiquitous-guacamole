
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "tfstate.manero.io"
    region = "us-east-1"
    key = "ubiquitous-guacamole/terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}
