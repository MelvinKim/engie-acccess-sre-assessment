variable "region" {
  type = string
  default = "us-west-2"
}

variable "elb_name" {
    type    = string
    default = "sre-application-alb"
}

variable "vpc_id" {
    type    = string
    default = "vpc-06427c4e4cced823c"
}

variable "public_subnet_ids" {
    type = list(string)
      default = [ "subnet-0da8d7c55226a2660", "subnet-0de45207614223287", "subnet-0638ee5205836319e", "subnet-0c2d9e0f419303060" ]
}

variable "key_name" {
  type = string
  description = "AWS key pair name"
  default = "sre-challenge"
}

variable "code_deploy_role_name" {
  type = string
  default = "codedeployrole"
}