resource "aws_security_group" "agrynov-cluster" {
  name        = "${var.name}-eks-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    { Name = "${var.name}-eks-sg" }
  )
}

resource "aws_security_group" "agrynov-node" {
  name        = "${var.name}-eks-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    { Name = "${var.name}-eks-node-sg" }
  )
}

data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

# Override with variable or hardcoded value if necessary
locals {
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.response_body)}/32"
}

resource "aws_security_group_rule" "kubeedge-cluster-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.agrynov-cluster.id
  to_port           = 443
  type              = "ingress"

  depends_on = [aws_security_group.agrynov-cluster]
}

# Allow nodes to communicate with the cluster API Server
resource "aws_security_group_rule" "kubeedge-cluster-ingress-nodes-https" {
  source_security_group_id = aws_security_group.agrynov-node.id
  description               = "Allow nodes to communicate with the cluster API Server"
  from_port                 = 443
  protocol                  = "tcp"
  security_group_id         = aws_security_group.agrynov-cluster.id
  to_port                   = 443
  type                      = "ingress"

  depends_on = [
    aws_security_group.agrynov-cluster,
    aws_security_group.agrynov-node
  ]
}

# Додаємо правила для нод
resource "aws_security_group_rule" "nodes-ingress-self" {
  type              = "ingress"
  from_port          = 0
  to_port            = 65535
  protocol           = "tcp"
  self               = true
  security_group_id  = aws_security_group.agrynov-node.id
  description        = "Allow nodes to communicate with each other"
}

resource "aws_security_group_rule" "nodes-ingress-cluster" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.agrynov-cluster.id
  security_group_id        = aws_security_group.agrynov-node.id
  description              = "Allow cluster to communicate with nodes"
}

# NodePort rules for external access
resource "aws_security_group_rule" "nodes-ingress-argocd" {
  type              = "ingress"
  from_port         = 30080
  to_port           = 30080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.agrynov-node.id
  description       = "Allow ArgoCD NodePort access"
}

resource "aws_security_group_rule" "nodes-ingress-nginx" {
  type              = "ingress"
  from_port         = 31753
  to_port           = 31753
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.agrynov-node.id
  description       = "Allow Nginx Ingress NodePort access"
}

resource "aws_security_group_rule" "nodes-ingress-app" {
  type              = "ingress"
  from_port         = 30082
  to_port           = 30082
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.agrynov-node.id
  description       = "Allow Flask App NodePort access"
}
