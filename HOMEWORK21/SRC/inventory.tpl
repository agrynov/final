[web]
%{ for ip in instance_ips ~}
${ip} ansible_user=ec2-user ansible_ssh_private_key_file=./privatehw21.key
%{ endfor ~}

[all:vars]
ansible_python_interpreter=/usr/bin/python3
