variable "node_group_name" {
  type = string
  default = "node_group_one"
}

variable "worker_nodes_ami_type" {
  type = string
  default = "ami-0663b059c6536cac8" # Amazon Linux
}

variable "worker_nodes_instance_types" {
  type = list(string)
  default = [ "t2.micro" ]
}

variable "cluster_endpoint_public_access" {
  type = bool
  default = true
}

variable "cluster_version" {
  type = string
  default = "1.27"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "region" {
  type = string
  default = "us-west-2"
}

variable "cluster_autoscaler_role_arn" {
  type = string
}