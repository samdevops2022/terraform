variable "vpc_cidr_block" {}
variable "subnet_block" {}
variable "zone" {
    default = "us-east-1a"
}
variable "environ" {}
variable "instance_type" {}
variable "pub_key_loc" {}
variable "start_script" {}