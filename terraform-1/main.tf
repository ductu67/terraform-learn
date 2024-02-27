// Tao tai nguyen vpc tren aws
// main la ten resource
resource "aws_vpc" "main" {
    // dai mang IPv4
    cidr_block       = "10.0.0.0/16"
    instance_tenancy = "default"
    //
    tags = {
        Name = "main"
    }
}

resource "aws_vpc" "tund" {
    // dai mang IPv4
    cidr_block       = "10.0.0.0/16"
    instance_tenancy = "default"
    //
    tags = {
        Name = "main"
    }
}