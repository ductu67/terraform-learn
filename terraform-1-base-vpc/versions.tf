terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.11"
      }
    }
    // version of terraform
    required_version = ">= 1.3.0"
} 

provider "aws" {
  region = "ap-southeast-1"
}

