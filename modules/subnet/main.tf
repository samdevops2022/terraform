resource "aws_subnet" "app_subnet1" {
    vpc_id = var.vpc_id 
    cidr_block = var.app_subnet_block
    availability_zone = var.zone
    tags = {
      "Name" = "${var.environ}-subnet1"
    }
}
/*resource "aws_route_table" "app_rtb" {
    vpc_id = aws_vpc.app_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.app_igw.id
    }
    tags = {
        Name: "${var.environ}-rtb"
    }
}*/
resource "aws_internet_gateway" "app_igw" {
    vpc_id = var.vpc_id
    tags = {
        Name: "${var.environ}-igw"
    }
}
/*resource "aws_route_table_association" "app_rtb_sub" {
    subnet_id = aws_subnet.app_subnet1.id
    route_table_id = aws_route_table.app_rtb.id
}
*/
resource "aws_default_route_table" "main-rtb" {
    default_route_table_id = var.def_rtb_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.app_igw.id
    }  
    tags = {
        Name: "${var.environ}-main-rtb"
    }   
  
}