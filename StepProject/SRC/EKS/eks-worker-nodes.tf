resource "aws_eks_node_group" "agrynov" {
  cluster_name    = aws_eks_cluster.agrynov.name
  node_group_name = "${var.name}-v3"
  node_role_arn   = aws_iam_role.agrynov-node.arn
  subnet_ids      = var.subnets_ids

  depends_on = [
    aws_iam_role_policy_attachment.agrynov-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.agrynov-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.agrynov-node-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.agrynov-node-AmazonEC2ReadOnlyAccess,
    aws_security_group_rule.kubeedge-cluster-ingress-nodes-https,
  ]

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  instance_types = var.node_instance_types

  labels = {
    "node-type" : "production"
  }

  disk_size = 50
  tags = merge(
    var.tags,
    { Name = "agrynov-node-group" }
  )
}
