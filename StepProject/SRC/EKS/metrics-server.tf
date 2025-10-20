# Metrics Server - не обов'язковий для базового функціонування
# resource "helm_release" "metrics" {
#   depends_on       = [aws_eks_node_group.agrynov]
#   name             = "metrics-server"
#   repository       = "https://kubernetes-sigs.github.io/metrics-server"
#   chart            = "metrics-server"
#   version          = var.metrics_server_version
#   namespace        = "kube-system"
#   create_namespace = true
# }
