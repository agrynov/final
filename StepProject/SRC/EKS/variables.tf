variable "name" {
  description = "Prefix name for all resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnets_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "tags" {
  description = "Tags"
  type        = map(string)
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "iam_profile" {
  description = "AWS CLI profile"
  type        = string
  default     = null
}

variable "zone_name" {
  description = "Route53 zone"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = ""
}

variable "node_group_name" {
  description = "Node group name"
  type        = string
  default     = ""
}

variable "node_instance_types" {
  description = "Instance types"
  type        = list(string)
  default     = ["t2.micro"]
}

variable "node_desired_size" {
  description = "Desired nodes"
  type        = number
  default     = 4
}

variable "node_min_size" {
  description = "Min nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Max nodes"
  type        = number
  default     = 5
}

variable "eks_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "coredns_version" {
  description = "CoreDNS version"
  type        = string
  default     = "v1.12.2-eksbuild.4"
}

variable "ingress_nginx_version" {
  description = "Nginx Ingress version"
  type        = string
  default     = "4.10.0"
}

variable "metrics_server_version" {
  description = "Metrics Server version"
  type        = string
  default     = "3.12.1"
}
