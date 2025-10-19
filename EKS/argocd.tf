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
          "type" = "LoadBalancer"
          "annotations" = {
            "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
            "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
            "service.beta.kubernetes.io/aws-load-balancer-ssl-cert" = module.acm.acm_certificate_arn
            "service.beta.kubernetes.io/aws-load-balancer-ssl-ports" = "https"
            "service.beta.kubernetes.io/aws-load-balancer-backend-protocol" = "http"
          }
        }
        "ingress" = {
          "enabled" = true
          "ingressClassName" = "nginx"
          "annotations" = {
            "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
            "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
            "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
          }
          "hosts" = ["argocd.${var.name}.${var.zone_name}"]
          "tls" = [
            {
              "secretName" = "argocd-tls"
              "hosts" = ["argocd.${var.name}.${var.zone_name}"]
            }
          ]
        }
      }
      "configs" = {
        "cm" = {
          "url" = "https://argocd.${var.name}.${var.zone_name}"
        }
      }
    })
  ]

  depends_on = [
    helm_release.nginx_ingress,
    module.acm
  ]
}

# ArgoCD Application for our app
# resource "kubernetes_manifest" "argocd_app" {
#   manifest = {
#     "apiVersion" = "argoproj.io/v1alpha1"
#     "kind"       = "Application"
#     "metadata" = {
#       "name"      = "danit-app"
#       "namespace" = "argocd"
#       "finalizers" = [
#         "resources-finalizer.argocd.argoproj.io"
#       ]
#     }
#     "spec" = {
#       "project" = "default"
#       "source" = {
#         "repoURL"        = "https://github.com/agrynov/final.git"
#         "targetRevision" = "HEAD"
#         "path"           = "step-final/k8s"
#       }
#       "destination" = {
#         "server"    = "https://kubernetes.default.svc"
#         "namespace" = "default"
#       }
#       "syncPolicy" = {
#         "automated" = {
#           "prune"    = true
#           "selfHeal" = true
#         }
#         "syncOptions" = [
#           "CreateNamespace=true"
#         ]
#         "retry" = {
#           "limit" = 5
#           "backoff" = {
#             "duration"    = "5s"
#             "factor"      = 2
#             "maxDuration" = "3m"
#           }
#         }
#       }
#     }
#   }

#   depends_on = [
#     helm_release.argocd
#   ]
# }
