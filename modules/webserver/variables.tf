variable "image_name" {}
variable "image_arch" {}
variable "vpc_id" {}
variable "environ" {}
variable "pub_key_loc" {}
variable "zone" {}
variable "subnet_id" {}
variable "instance_type" {}
variable "instance_names"{
    type = list(string)
}
