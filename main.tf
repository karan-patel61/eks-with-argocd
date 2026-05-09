module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"
  
  cluster_name    = "gitops-cluster"
  cluster_version = 1.33

  # Public access (for your local terminal) restricted by AWS IAM
  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    general = {
      desired_size = 2
      instance_types = ["t3.medium"]
      
      # Attaching the SG we defined in security_groups.tf
      vpc_security_group_ids = [aws_security_group.eks_nodes.id]
    }
  }

cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent              = true
      # This is the "magic link" that connects the add-on to the IAM role
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
    }
  }
  
}