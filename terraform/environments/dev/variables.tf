variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-2"
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "eks-platform"
}