terraform {
  backend "s3" {
    bucket = "mycloudprojects"
    key    = "State-Files/terraform.tfstate"
    region = "us-east-1"
  }
}

terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~>5.11"
      }
    }
}