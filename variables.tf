variable "vpc_cidr_block" {}
variable "zone" {
    default = "us-east-1a"
}
variable "environ" {}
variable "instance_type" {}
variable "pub_key_loc" {}
variable "priv_key_loc" {}
variable "subnet_block" {}
#variable "start_script" {}
variable "image_name" {}
variable "image_arch" {}
variable "instance_names"{
    type = list(string)
}
