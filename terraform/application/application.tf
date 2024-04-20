resource "aws_launch_template" "application" {
    name                   = "sre_application"
    image_id               = "${var.application_ami}"
    key_name               = var.key_name
    instance_type          = "${var.instance_type}"
    vpc_security_group_ids = concat(var.security_groups, [var.alb_security_group_id])

    tag_specifications {
        resource_type = "instance"

        tags = merge(            
            {
                Name = "sre_application"
            },
            var.extra_tags,
            )
    }
  
    user_data              = base64encode(templatefile("${path.module}/userdata.tmpl", {}))

    iam_instance_profile {
        name = var.code_deploy_instance_profile_name
    }

    lifecycle {
        create_before_destroy =  true
    }

    credit_specification {
        cpu_credits = var.cpu_credits
    }
    block_device_mappings {
      device_name = var.block_device_name

    ebs {
      volume_size = var.ebs_volume_size
      volume_type = var.ebs_volume_type
    }
  }
}

resource "aws_autoscaling_group" "application" {
    name = "application"
    min_size = "${var.min_size}"
    desired_capacity = "${var.desired_capacity}"
    max_size = "${var.max_size}"
    vpc_zone_identifier = var.vpc_zone_identifier

    launch_template {
      id        = "${aws_launch_template.application.id}"
      version   = "$Latest"
    }
    
    target_group_arns = [var.target_group_arn]
}

resource "aws_autoscaling_policy" "application_cpu" {
    name                   = "cpu-autoscaling"
    adjustment_type        = "ChangeInCapacity"
    policy_type            = "TargetTrackingScaling"
    autoscaling_group_name = aws_autoscaling_group.application.name
    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = var.cpuscale
    }
    depends_on = [aws_autoscaling_group.application]
}

