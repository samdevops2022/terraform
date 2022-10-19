resource "aws_vpc" "app_vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
      "Name" = "${var.environ}-vpc"
    }
}
 
resource "aws_subnet" "app_subnet1" {
    vpc_id = aws_vpc.app_vpc.id
    cidr_block = var.subnet_block
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
    vpc_id = aws_vpc.app_vpc.id
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
    default_route_table_id = aws_vpc.app_vpc.default_route_table_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.app_igw.id
    } 
    tags = {
        Name: "${var.environ}-main-rtb"
    }   
  
}
resource "aws_security_group" "app-sg" {
    name = "app-sg"
    vpc_id = aws_vpc.app_vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp" 
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp" 
        cidr_blocks = ["0.0.0.0/0"]        
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1" 
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      "Name" = "${var.environ}-sg"
    }
}
data "aws_ami" "amzaon_linux_img_lts" {
    most_recent = true
    owners = ["amazon"]
    filter {
      name = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }
    }
/*output "aws_ami_id" {
    value = data.aws_ami.amzaon_linux_img_lts.id
}*/
resource "aws_key_pair" "app-sshkey" {
    key_name = "app-sshkey"
    public_key = file(var.pub_key_loc)
}

resource "aws_instance" "app-server" {
    ami = data.aws_ami.amzaon_linux_img_lts.id
    instance_type = var.instance_type
    subnet_id = aws_subnet.app_subnet1.id
    vpc_security_group_ids = [aws_security_group.app-sg.id]
    availability_zone = var.zone

    associate_public_ip_address = true
    key_name = aws_key_pair.app-sshkey.key_name

    tags = {
      "Name" = "${var.environ}-app-server"
    }

    user_data = file(var.start_script)
}
output "aws_pub_ip" {
    value = aws_instance.app-server.public_ip
}
output "aws_priv_ip" {
    value = aws_instance.app-server.private_ip
}
