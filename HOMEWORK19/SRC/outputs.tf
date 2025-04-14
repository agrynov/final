output "public_instance_ip" {
    description = "Public EC2"
    value = aws_instance.agrynov-instance-public.public_ip
}

output "privaate_instanse_ip" {
    description = "Private EC2"
    value = aws_instance.agrynov-instance-private.private_ip
}