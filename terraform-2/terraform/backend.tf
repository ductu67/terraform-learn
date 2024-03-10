terraform {
  backend "s3" {
    bucket = "mybucket"
    key = "path/to/my/key"
    region = "value"
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