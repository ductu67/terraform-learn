provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "hello" {
  ami           = "ami-09dd2e08d601bff67"
  instance_type = "t2.micro"
  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_s3_bucket" "terraform-bucket" {
  bucket = "terraform-series-bucket"

  tags = {
    Name        = "Terraform Series"
  }
}