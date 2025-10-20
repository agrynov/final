# ArgoCD Installation
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.51.6"
  namespace        = "argocd"
  create_namespace = true

  values = [
    yamlencode({
      "global" = {
        "domain" = "argocd.${var.name}.${var.zone_name}"
      }
      "server" = {
        "service" = {
          "type" = "NodePort"
          "nodePorts" = {
            "http" = "30080"
            "https" = "30443"
          }
        }
        "ingress" = {
          "enabled" = true
          "ingressClassName" = "nginx"
          "annotations" = {
            "nginx.ingress.kubernetes.io/ssl-redirect" = "false"
            "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
          }
          "hosts" = ["argocd.${var.name}.${var.zone_name}"]
        }
      }
      "configs" = {
        "cm" = {
          "url" = "http://argocd.${var.name}.${var.zone_name}"
        }
      }
    })
  ]

  # depends_on = [
  #   helm_release.nginx_ingress
  # ]
}

# ArgoCD Application for our app
resource "kubernetes_manifest" "argocd_app" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind"       = "Application"
    "metadata" = {
      "name"      = "agrynov-app"
      "namespace" = "argocd"
      "finalizers" = [
        "resources-finalizer.argocd.argoproj.io"
      ]
    }
    "spec" = {
      "project" = "default"
      "source" = {
        "repoURL"        = "https://github.com/agrynov/final"
        "targetRevision" = "HEAD"
        "path"           = "k8s"
      }
      "destination" = {
        "server"    = "https://kubernetes.default.svc"
        "namespace" = "agrynov-app"
      }
      "syncPolicy" = {
        "automated" = {
          "prune"    = true
          "selfHeal" = true
        }
        "syncOptions" = [
          "CreateNamespace=true"
        ]
        "retry" = {
          "limit" = 5
          "backoff" = {
            "duration"    = "5s"
            "factor"      = 2
            "maxDuration" = "3m"
          }
        }
      }
    }
  }

  depends_on = [
    helm_release.argocd
  ]
}
