variable "application_ami" {
    type    = string
    default = "ami-08116b9957a259459"
}

variable "security_groups" {
    type = list(string)
    default = ["sg-0f46f20bc12ffab27"]
}

variable "alb_security_group_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "min_size" {
    type = number
    default = 1
}

variable "desired_capacity" {
  type = number
  default = 2
}

variable "instance_type" {
    type = string
    default = "t3.micro"
}

variable "max_size" {
    type = number
    default = 4
}

variable "cpuscale" {
    type = number
    default = 60.0
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

variable "iam_instance_profile_name" {
  type = string
  default = "CodeDeploy-EC2-Instance-Profile"
}

variable "lifecycle_create_before_destroy" {
  type = bool
  default = true
}

variable "block_device_name" {
  type = string
  default = "/dev/sda1"
}

variable "ebs_volume_size" {
  type = number
  default = 100
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