output "instance_public_ips" {
  value = [for instance in aws_instance.hw21-agrynov : instance.public_ip]
}


output "ssh_key_pair_name" {
  value = tls_private_key.ssh-agrynov.private_key_openssh
  sensitive = true
}