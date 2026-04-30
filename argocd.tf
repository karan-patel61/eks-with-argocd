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
  version    = "6.7.11" # Standard version for 2026

  # This setting changes the service type to LoadBalancer
  # This tells AWS to create an actual URL you can visit in your browser
  set = [{
    name  = "server.service.type"
    value = "LoadBalancer"
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