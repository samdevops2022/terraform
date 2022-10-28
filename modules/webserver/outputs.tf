output "aws_ami_id" {
    value = data.aws_ami.amzaon_linux_img_lts.id
}
output "aws_pub_ip" {
    value = aws_instance.ci-nexus[*].public_ip
}
output "aws_priv_ip" {
    value = aws_instance.ci-nexus[*].private_ip
}