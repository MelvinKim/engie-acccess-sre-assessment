variable "application_ami" {
    type    = string
    default = "ami-08116b9957a259459"
    description = "The ID of the AMI (Amazon Machine Image) used to launch EC2 instances."
}

variable "security_groups" {
    type = list(string)
    default = ["sg-08ab8d901cf98891b"]
    description = "A list of security group IDs that will be applied to the launched EC2 instances."
}

variable "alb_security_group_id" {
  type = string
  description = "The ID of the security group that will be used by the Application Load Balancer."
}

variable "target_group_arn" {
  type = string
  description = "The ARN (Amazon Resource Name) of the target group associated with the Application Load Balancer."
}

variable "min_size" {
    type = number
    default = 1
    description = "The minimum number of EC2 instances to launch in the Auto Scaling Group."
}

variable "desired_capacity" {
  type = number
  default = 2
  description = "The desired number of EC2 instances to maintain in the Auto Scaling Group."
}

variable "instance_type" {
    type = string
    default = "t3.micro"
    description = "The type of EC2 instance to launch (e.g., t3.micro, m5.xlarge)."
}

variable "max_size" {
    type = number
    default = 4
    description = "The maximum number of EC2 instances that can be launched in the Auto Scaling Group."
}

variable "cpuscale" {
    type = number
    default = 60.0
    description = "The CPU target utilization for the Auto Scaling Group (percentage)."
}

variable "cpu_credits" {
    type = string
    default = "unlimited"
    description = "CPU credits for the burstable instance types (unlimited or a specific value)."
}

variable "extra_tags" {
  type = map(string)
  default = {
    Type        = "worker"
    Environment = "production"
    Owner       = "software"
  }
  description = "A map of additional tags to be applied to the launched EC2 instances."
}

variable "iam_instance_profile_name" {
  type = string
  default = "CodeDeploy-EC2-Instance-Profile"
  description = "The name of the IAM instance profile to be attached to the EC2 instances."
}

variable "lifecycle_create_before_destroy" {
  type = bool
  default = true
  description = "Whether to create new instances before destroying old ones during replacement (true) or vice versa (false)."
}

variable "block_device_name" {
  type = string
  default = "/dev/sda1"
  description = "The name of the block device where the EBS volume will be attached."
}

variable "ebs_volume_size" {
  type = number
  default = 100
  description = "The size of the EBS volume to be attached to the EC2 instances (in GiB)."
}

variable "ebs_volume_type" {
  type = string
  default = "gp3"
  description = "The type of the EBS volume to be attached (e.g., gp2, st1)."
}

variable "key_name" {
  type = string
  description = "AWS key pair name"
  default = "sre_application"
}

variable "vpc_zone_identifier" {
  type = list(string)
  default = [ "subnet-0da8d7c55226a2660", "subnet-0de45207614223287", "subnet-0638ee5205836319e", "subnet-0c2d9e0f419303060" ]
  description = "A list of availability zones within the VPC where instances can be launched."
}

# variable "code_deploy_role_name" {
#   type = string
# }

# variable "code_deploy_instance_profile_name" {
#   type = string
# }