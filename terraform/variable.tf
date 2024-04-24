variable "region" {
  type = string
  default = "us-west-2"
  description = "The AWS region where resources will be deployed."
}

variable "elb_name" {
    type    = string
    default = "sre-application-alb"
    description = "The name for the Application Load Balancer."
}

variable "vpc_id" {
    type    = string
    default = "vpc-06427c4e4cced823c"
    description = "The ID of the VPC that will be used for resources."
}

variable "public_subnet_ids" {
    type = list(string)
    default = [ "subnet-0da8d7c55226a2660", "subnet-0de45207614223287", "subnet-0638ee5205836319e", "subnet-0c2d9e0f419303060" ]
    description = "A list of public subnet IDs within the VPC."
}

variable "key_name" {
  type = string
  description = "AWS key pair name"
  default = "sre_application"
}

variable "code_deploy_role_name" {
  type = string
  default = "codedeployrole"
  description = "The name of the IAM role used by CodeDeploy."
}
