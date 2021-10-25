variable "region" {
  default     = "us-west-1"
  description = "AWS region"
}

variable "cluster_name" {
  default = "demo-cluster"
  type     = string
  description = "Default cluster name"
}