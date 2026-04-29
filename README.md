# eks-with-argocd

This repository deploys an Amazon EKS cluster and ArgoCD Helm installation using Terraform.

## Prerequisites

- Terraform 1.0+ installed
- AWS CLI configured with credentials and default region
- IAM permissions to create EKS, VPC, IAM, and related resources

## Usage

Initialize the working directory:

```bash
terraform init
```

Preview the planned changes:

```bash
terraform plan
```

Create the infrastructure:

```bash
terraform apply
```

Destroy the infrastructure when you are done:

```bash
terraform destroy
```

## Access the EKS cluster

After the cluster is created, update your local kubeconfig with:

```bash
aws eks update-kubeconfig --region $(terraform output -raw region) --name $(terraform output -raw cluster_name)
```

Then verify connectivity with:

```bash
kubectl get nodes
```
