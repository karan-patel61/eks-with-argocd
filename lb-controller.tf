resource "helm_release" "lbc" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.7.2" # Check for latest version in 2026
  # Increase timeout to 15 minutes
#   timeout    = 900
#   wait       = true

  set = [{
    name  = "clusterName"
    value = module.eks.cluster_name
  },
  {
    name  = "serviceAccount.create"
    value = "true"
  },
  {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  },
  {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.lbc_irsa_role.iam_role_arn
  },
  # This ensures the CRDs are installed
  {
    name  = "installCRDs"
    value = "true"
  }
  ]

  depends_on = [module.eks]
}