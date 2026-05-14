resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }

  depends_on = [module.eks]
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = "9.5.0"


  set = [{
    name  = "server.service.type"
    value = "ClusterIP"
  }]

  depends_on = [module.eks] # CRITICAL: Don't try to install until EKS is ready

}

# Wait for the ArgoCD Service to be created by the Helm chart
data "kubernetes_service_v1" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
  }
  # This ensures we don't look for the service before the chart starts installing
  depends_on = [helm_release.argocd]
}

output "argocd_server_url" {
  value = data.kubernetes_service_v1.argocd_server.status[0].load_balancer[0].ingress[0].hostname
  
}