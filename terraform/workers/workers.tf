resource "aws_launch_template" "workers" {
    name                   = "workers_${var.name}"
    image_id               = var.workers_ami
    key_name               = var.key_name
    instance_type          = var.instance_type
    vpc_security_group_ids = var.security_groups
    tag_specifications {
        resource_type = "instance"

        tags = merge(
            {
                Name = "workers_${var.name}"
            },
            var.extra_tags,
            )
    }

    iam_instance_profile {
        name = var.code_deploy_instance_profile_name
    }

    lifecycle {
        create_before_destroy = true
    }

    credit_specification {
        cpu_credits = var.cpu_credits
    }

    block_device_mappings {
      device_name = var.device_name

      ebs {
        volume_size = var.ebs_volume_size
        volume_type = var.ebs_volume_type
      }
  }
    
}

resource "aws_autoscaling_group" "workers" {
    name = "workers_${var.name}"
    min_size = var.min_size
    desired_capacity = var.desired_capacity
    max_size = var.max_size
    vpc_zone_identifier = var.vpc_zone_identifier
 
    launch_template {
      id        = aws_launch_template.workers.id
      version   = "$Latest"
    }
}

resource "aws_autoscaling_policy" "workers_cpu" {
    name                   = "cpu-autoscaling"
    adjustment_type        = "ChangeInCapacity"
    policy_type            = "TargetTrackingScaling"
    autoscaling_group_name = aws_autoscaling_group.workers.name
    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = var.cpuscale
    }
    depends_on = [aws_autoscaling_group.workers]
}

