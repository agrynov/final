# Nginx Ingress Controller
resource "helm_release" "nginx_ingress" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = var.ingress_nginx_version
  namespace        = "ingress-nginx"
  create_namespace = true

  set {
    name  = "controller.service.type"
    value = "NodePort"
  }
  
  set {
    name  = "controller.service.nodePorts.http"
    value = "30080"
  }
  
  set {
    name  = "controller.service.nodePorts.https"
    value = "30443"
  }
}

