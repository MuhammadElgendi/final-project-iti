
# EKS CLUSTER
resource "aws_eks_cluster" "eks" {
  name = "iti-cluster"

  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.21"
 

  vpc_config {
    endpoint_private_access = true 
    endpoint_public_access = true 
    public_access_cidrs     = ["0.0.0.0/0"]
    subnet_ids =[aws_subnet.private.id,aws_subnet.private02.id,aws_subnet.public.id]

  }

  depends_on = [
    aws_iam_role.eks_cluster,
  ]
}
##########################
# IAM ROLE FOR EKS CLUSTER
resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.eks_cluster.name
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
 role   = aws_iam_role.eks_cluster.name
}
##########################
# EKS CLUSTER SECUIRT GROUP
resource "aws_security_group" "eks_cluster" {
  name        = "cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.environment.id

  tags = {
    Name = "cluster-sg"
  }
}

resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "egress"
}


