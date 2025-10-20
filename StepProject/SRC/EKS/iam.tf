# For cluster
resource "aws_iam_role" "cluster" {
  name = "${var.name}-eks-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
    }
  ]
}
POLICY
  tags = merge(
    var.tags,
    { Name = "${var.name}-eks-role" }
  )
}

resource "aws_iam_role_policy_attachment" "agrynov-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "agrynov-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster.name
}

# EKS Auto Mode policies
resource "aws_iam_role_policy_attachment" "agrynov-cluster-AmazonEKSBlockStoragePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "agrynov-cluster-AmazonEKSComputePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSComputePolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "agrynov-cluster-AmazonEKSLoadBalancingPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "agrynov-cluster-AmazonEKSNetworkingPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
  role       = aws_iam_role.cluster.name
}

data "tls_certificate" "cert" {
  url = aws_eks_cluster.agrynov.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "openid_connect" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cert.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.agrynov.identity[0].oidc[0].issuer

  depends_on = [
    aws_eks_cluster.agrynov,
    data.tls_certificate.cert
  ]
}

module "oidc-provider-data" {
  source     = "reegnz/oidc-provider-data/aws"
  version    = "0.0.3"
  issuer_url = aws_eks_cluster.agrynov.identity[0].oidc[0].issuer

  depends_on = [aws_eks_cluster.agrynov]
}

# For nodes
resource "aws_iam_role" "agrynov-node" {
  name = "${var.name}-eks-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = merge(
    var.tags,
    { Name = "${var.name}-eks-node-role" }
  )
}

resource "aws_iam_policy" "secrets_policy" {
  name        = "GetSecrets"
  path        = "/"
  description = "Policy to read aws secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      #{
      #  "Sid" : "AllowListHostedZones",
      #  "Effect" : "Allow",
      #  "Action" : "route53:ChangeResourceRecordSets",
      #  "Resource" : data.aws_route53_zone.kubeedge.arn
      #},
      {
        "Sid" : "AllowListHostedZones1",
        "Effect" : "Allow",
        "Action" : [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "agrynov-node-AmazonSecretsPolicy" {
  policy_arn = aws_iam_policy.secrets_policy.arn
  role       = aws_iam_role.agrynov-node.name
}

resource "aws_iam_role_policy_attachment" "agrynov-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.agrynov-node.name
}

resource "aws_iam_role_policy_attachment" "agrynov-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.agrynov-node.name
}

resource "aws_iam_role_policy_attachment" "agrynov-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.agrynov-node.name
}

# Додаємо політику для опису EC2 інстансів (необхідно для bootstrap процесу)
resource "aws_iam_role_policy_attachment" "agrynov-node-AmazonEC2ReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  role       = aws_iam_role.agrynov-node.name
}

# Instance Profile для EKS нод
resource "aws_iam_instance_profile" "agrynov-node" {
  name = "${var.name}-eks-node-profile"
  role = aws_iam_role.agrynov-node.name

  tags = merge(
    var.tags,
    { Name = "${var.name}-eks-node-profile" }
  )
}
