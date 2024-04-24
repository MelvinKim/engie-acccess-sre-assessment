variable "node_group_name" {
  type = string
  default = "node_group_one"
  description = "The name for the EKS Node Group."
}

variable "worker_nodes_ami_type" {
  type = string
  default = "ami-0663b059c6536cac8" # Amazon Linux
  description = "The ID of the AMI (Amazon Machine Image) used to launch worker nodes in the EKS cluster (e.g., for Amazon Linux)."
}

variable "worker_nodes_instance_types" {
  type = list(string)
  default = [ "t3.medium" ]
  description = "A list of instance types for the worker nodes in the EKS cluster (e.g., t2.micro, m5.xlarge)."
}

variable "cluster_endpoint_public_access" {
  type = bool
  default = true
  description = "Whether the EKS cluster endpoint should be publicly accessible (true) or not (false)."
}

variable "cluster_version" {
  type = string
  default = "1.27"
  description = "The desired version of Kubernetes for the EKS cluster (e.g., 1.27)."
}

variable "vpc_id" {
  type = string
  description = "The ID of the VPC where the EKS cluster resources will be created."
}

variable "subnet_ids" {
  type = list(string)
  description = "A list of subnet IDs within the VPC where worker nodes will be launched."
}

variable "region" {
  type = string
  default = "us-west-2"
  description = "The AWS region where the EKS cluster will be deployed."
}

variable "cluster_autoscaler_role_arn" {
  type = string
  description = "The ARN (Amazon Resource Name) of the IAM role used by the EKS Cluster Autoscaler."
}