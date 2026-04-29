resource "aws_security_group" "eks_nodes" {
  name        = "eks-node-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow inter-node communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-node-security-group"
  }
}
