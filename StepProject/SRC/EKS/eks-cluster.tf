resource "aws_eks_cluster" "agrynov" {
  name     = var.name
  role_arn = aws_iam_role.cluster.arn
  version  = var.eks_version

  vpc_config {
    security_group_ids = [aws_security_group.agrynov-cluster.id]
    subnet_ids         = var.subnets_ids
    endpoint_private_access = false
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.agrynov-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.agrynov-cluster-AmazonEKSVPCResourceController,
  ]
  tags = merge(
    var.tags,
    { Name = "${var.name}" }
  )
}

data "aws_eks_cluster_auth" "agrynov" {
  name = aws_eks_cluster.agrynov.name
}

# CoreDNS встановлюється автоматично AWS після створення нод
# resource "aws_eks_addon" "coredns" {
#   cluster_name                = var.name
#   addon_name                  = "coredns"
#   addon_version               = var.coredns_version
#   resolve_conflicts_on_create = "OVERWRITE"
#
#   depends_on = [aws_eks_node_group.agrynov]
# }
