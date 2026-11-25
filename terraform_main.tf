terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# EKS Cluster for Ray + vLLM
resource "aws_eks_cluster" "llm_cluster" {
  name     = "llm-prod-cluster"
  role_arn = aws_iam_role.eks_cluster.arn
  
  vpc_config {
    subnet_ids = aws_subnet.private[*].id
  }
}

# GPU Node Group - A100 80GB
resource "aws_eks_node_group" "gpu_nodes" {
  cluster_name    = aws_eks_cluster.llm_cluster.name
  node_group_name = "gpu-a100"
  instance_types  = ["p4d.24xlarge"]  # 8x A100
  
  scaling_config {
    desired_size = 2
    max_size     = 10
    min_size     = 1
  }
  
  labels = {
    "nvidia.com/gpu" = "true"
    "workload"       = "llm-inference"
  }
}

# S3 for model storage
resource "aws_s3_bucket" "model_bucket" {
  bucket = "llm-models-dpo-70b"
}

# Redis for rate limiting
resource "aws_elasticache_cluster" "redis" {
  cluster_id      = "llm-redis"
  engine          = "redis"
  node_type       = "cache.r6g.large"
  num_cache_nodes = 1
}
