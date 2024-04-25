terraform {
  backend "s3" {
    bucket = "mycloudprojects1"
    key    = "State-Files/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
