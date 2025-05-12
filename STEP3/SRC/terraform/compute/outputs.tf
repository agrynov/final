output "jenkins_master_public_ip" {
  value = aws_instance.sp-ag-jenkins-master.public_ip
}

output "jenkins_master_private_ip" {
  value = aws_instance.sp-ag-jenkins-master.private_ip
}

output "jenkins_worker_private_ip" {
  value = aws_instance.sp-ag-jenkins-worker.private_ip
}
