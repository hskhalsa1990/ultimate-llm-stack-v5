# Multi-Region AWS EKS Deployment
variable "regions" {
  default = ["us-east-1", "eu-west-1", "ap-south-1"]
}

module "eks_cluster" {
  source   = "./modules/eks"
  for_each = toset(var.regions)
  
  region       = each.value
  cluster_name = "llm-prod-${each.value}"
  
  node_groups = {
    gpu = {
      instance_types = ["p4d.24xlarge"]
      desired_size   = 2
      max_size       = 10
      labels = {
        "workload" = "llm-inference"
        "region"   = each.value
      }
    }
  }
}

# Global Load Balancer
resource "aws_route53_record" "global_lb" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "api.llm.company.com"
  type    = "A"
  
  latency_routing_policy {
    region = each.value
  }
  
  set_identifier = each.value
  records        = [module.eks_cluster[each.value].cluster_endpoint]
}

# Cross-region S3 replication for models
resource "aws_s3_bucket_replication_configuration" "model_replication" {
  bucket = aws_s3_bucket.models.id
  role   = aws_iam_role.replication.arn
  
  rule {
    id     = "replicate-to-all-regions"
    status = "Enabled"
    destination {
      bucket = aws_s3_bucket.models_replica[var.regions[1]].arn
    }
  }
}
