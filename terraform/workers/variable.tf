variable "workers_ami" {
    type    = string
    default = "ami-08116b9957a259459"
}

variable "security_groups" {
    type = list(string)
    default = ["sg-0f46f20bc12ffab27"]
}

variable "name" {
    type = string
}

variable "min_size" {
    type = number
    default = 1
}

variable "max_size" {
    type = number
    default = 1
}

variable "desired_capacity" {
  type = number
  default = 1
}

variable "instance_type" {
    type = string
    default = "t3.nano"
}

variable "cpuscale" {
    type = number
    default = 40.0
}

variable "cpu_credits" {
    type = string
    default = "unlimited"
}

variable "extra_tags" {
  type = map(string)
  default = {
    Type        = "worker"
    Environment = "production"
    Owner       = "software"
  }
}

variable "lifecycle_create_before_destroy" {
  type = bool
  default = true
}

variable "iam_instance_profile" {
  type = string
  default = "CodeDeploy-EC2-Instance-Profile"
}

variable "device_name" {
  type = string
  default = "/dev/sda1"
}

variable "ebs_volume_size" {
  type = number
  default = 20
}

variable "ebs_volume_type" {
  type = string
  default = "gp3"
}

variable "key_name" {
  type = string
  description = "AWS key pair name"
  default = "sre-challenge"
}

variable "vpc_zone_identifier" {
  type = list(string)
  default = [ "subnet-0da8d7c55226a2660", "subnet-0de45207614223287", "subnet-0638ee5205836319e", "subnet-0c2d9e0f419303060" ]
}

variable "code_deploy_role_name" {
  type = string
}

variable "code_deploy_instance_profile_name" {
  type = string
}