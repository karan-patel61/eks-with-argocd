resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = "monitoring"
  }

  depends_on = [module.eks]
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"
  version    = "61.3.1" # Standard stable version

  # This allows Grafana to be accessed via an AWS Load Balancer
  set = [{
    name  = "grafana.service.type"
    value = "LoadBalancer"
  },
  {
    # Ensure Prometheus has enough storage for history (using AWS EBS)
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
    value = "10Gi"
  }]

  # Ensure Prometheus has enough storage for history (using AWS EBS)
#   set = {
#     name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
#     value = "10Gi"
#   }

  depends_on = [module.eks]
}