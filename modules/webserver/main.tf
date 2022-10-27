resource "aws_security_group" "app-sg" {
    vpc_id = var.vpc_id

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
      values = [var.image_name]
    }
    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }
}
resource "aws_key_pair" "app-sshkey" {
    key_name = "app-sshkey"
    public_key = file(var.pub_key_loc)
}

resource "aws_instance" "ci-nexus" {
    ami = data.aws_ami.amzaon_linux_img_lts.id
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    vpc_security_group_ids = [aws_security_group.app-sg.id]
    associate_public_ip_address = true
    key_name = aws_key_pair.app-sshkey.key_name
    count = length(var.instance_names)
    tags = {
      "Name" = "${var.environ}-${var.instance_names[count.index]}"
    }
#    user_data = file("./server_script.sh")
}
