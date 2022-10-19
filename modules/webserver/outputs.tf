output "aws_ami_id" {
    value = data.aws_ami.amzaon_linux_img_lts.id
}
output "aws_pub_ip" {
    value = aws_instance.app-server.public_ip
}
output "aws_priv_ip" {
    value = aws_instance.app-server.private_ip
}