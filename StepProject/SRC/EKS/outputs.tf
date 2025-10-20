output "cluster_id" {
  description = "EKS cluster ID"
  value       = aws_eks_cluster.agrynov.id
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.agrynov.name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.agrynov.endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_eks_cluster.agrynov.vpc_config[0].cluster_security_group_id
}

output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = aws_eks_cluster.agrynov.arn
}

output "cluster_version" {
  description = "Kubernetes version"
  value       = aws_eks_cluster.agrynov.version
}

output "node_group_id" {
  description = "EKS node group ID"
  value       = aws_eks_node_group.agrynov.id
}

output "node_group_status" {
  description = "Node group status"
  value       = aws_eks_node_group.agrynov.status
}

output "kubectl_config_command" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.agrynov.name} --profile ${var.iam_profile}"
}

output "oidc_provider_arn" {
  description = "OIDC Provider ARN"
  value       = aws_iam_openid_connect_provider.openid_connect.arn
}

output "argocd_url" {
  description = "ArgoCD UI URL"
  value       = "http://argocd.${var.name}.${var.zone_name}"
}

output "app_url" {
  description = "Application URL"
  value       = "http://app.${var.name}.${var.zone_name}"
}
