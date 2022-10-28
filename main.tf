resource "aws_vpc" "app_vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
      "Name" = "${var.environ}-vpc"
    }
}
 
module "app-subnet" {
    source = "./modules/subnet"
    app_subnet_block = var.subnet_block
    zone = var.zone
    environ = var.environ
    vpc_id = aws_vpc.app_vpc.id
    def_rtb_id = aws_vpc.app_vpc.default_route_table_id
}

module "webserver" {
    source = "./modules/webserver"
    image_name = var.image_name
    vpc_id = aws_vpc.app_vpc.id
    environ = var.environ
    pub_key_loc = var.pub_key_loc
    zone = var.zone
    subnet_id = module.app-subnet.subnet.id
    instance_type = var.instance_type
    instance_names = var.instance_names
    image_arch = var.image_arch
}
