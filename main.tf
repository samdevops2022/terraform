variable "cidr_blocks" {
    description = "cidr blocks for vpc"
    type = list(object({
        cidr_block = string
        name = string
    }))
}
resource "aws_vpc" "sam_vpc" {
    cidr_block = var.cidr_blocks[0].cidr_block
    tags = {
      "Name" = var.cidr_blocks[0].name
    }
}
resource "aws_subnet" "sam_subnet" {
    vpc_id = aws_vpc.sam_vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    tags = {
      "Name" = "sam_subnet"
    }
}
data "aws_vpc" "vpc_data" {
    default = true
}
resource "aws_subnet" "def_subnet2" {
    vpc_id = data.aws_vpc.vpc_data.id
    cidr_block = "172.31.96.0/20"
    availability_zone = "us-east-1a"
    tags = {
      "Name" = "def_subnet2"
    }
}