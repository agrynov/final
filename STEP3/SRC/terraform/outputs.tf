output "sp-ag-jenkins_master_public_ip" {
  value = module.compute.jenkins_master_public_ip
}

output "sp-ag-jenkins_master_private_ip" {
  value = module.compute.jenkins_master_private_ip
}

output "sp-ag-jenkins_worker_private_ip" {
  value = module.compute.jenkins_worker_private_ip
}
