# module "payments_workers" {
#     source     = "./modules/workers"
#     name       = "payments_workers"
#     min_size   = 2
#     desired_capacity = 2
#     max_size   = 2
#     instance_type = "t3.nano"
#     cpuscale = 60.0
# }

# module "background_workers" {
#     source     = "./modules/workers"
#     name       = "background_workers"
#     min_size   = 2
#     desired_capacity = 2
#     max_size   = 2
#     cpuscale = 60.0
# }

# module "messaging_background_workers" {
#     source     = "./modules/workers"
#     name       = "messaging_background_workers"
#     min_size   = 1
#     max_size   = 4
# }

# resource "aws_autoscaling_schedule" "daily_messaging_scale_out" {
#     scheduled_action_name  = "evening_payments_scale_out"
#     min_size               = 1
#     max_size               = 4
#     desired_capacity       = -1
#     recurrence             = "0 5 * * *"
#     autoscaling_group_name = "${module.messaging_background_workers.scaling_group_id}"
# }

# resource "aws_autoscaling_schedule" "daily_messaging_scale_in" {
#     scheduled_action_name  = "daily_messaging_scale_in"
#     min_size               = 0
#     max_size               = 4
#     desired_capacity       = -1
#     recurrence             = "0 22 * * *"
#     autoscaling_group_name = "${module.messaging_background_workers.scaling_group_id}"
# }

# resource "aws_autoscaling_schedule" "evening_payments_scale_out" {
#     scheduled_action_name  = "evening_payments_scale_out"
#     min_size               = 4
#     max_size               = 8
#     desired_capacity       = -1
#     recurrence             = "0 15 * * *"
#     autoscaling_group_name = "${module.payments_workers.scaling_group_id}"
# }

# resource "aws_autoscaling_schedule" "evening_payments_scale_in" {
#     scheduled_action_name  = "evening_payments_scale_in"
#     min_size               = 2
#     max_size               = 8
#     desired_capacity       = -1
#     recurrence             = "0 18 * * *"
#     autoscaling_group_name = "${module.payments_workers.scaling_group_id}"
# }

## Application servers
module "application" {
    source     = "./modules/application"
    alb_security_group_id = aws_security_group.alb_security_group.id
    target_group_arn = aws_lb_target_group.application.arn

    min_size   = 1 # 2
    max_size   = 1 # 4
    desired_capacity = 1
}

resource "aws_security_group" "alb_security_group" {
  name        = "alb-security-group"
  description = "Security group for Application Load Balancer"

  vpc_id = var.vpc_id

  // Inbound rules: Allow HTTP and HTTPS traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    // Inbound rule for node node-exporter (used to export host metrics)
    ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For production use-cases, limit access to only prometheus servers
    }

    // Inbound rule for node node-exporter (used to export host metrics)
    ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For production use-cases, limit access to only prometheus servers
    }

    // Inbound rule for Grafana
    ingress {
      from_port = 3000
      to_port = 3000
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  // Outbound rule: Allow all traffic to go out
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-group"
  }
}

resource "aws_lb" "application" {
    name               = "sre-application-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb_security_group.id]
    subnets            = var.public_subnet_ids

    tags = {
        Name = "sre-application-alb"
    }
}

resource "aws_lb_target_group" "application" {
    name        = "sre-application-tg"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = "${var.vpc_id}"
    target_type = "instance"

    health_check {
        path                = "/"
        interval            = 30
        timeout             = 10
        healthy_threshold   = 3
        unhealthy_threshold = 3
    }

    tags = {
        Name = "sre-application-tg"
    }
}

resource "aws_lb_listener" "application" {
    load_balancer_arn = "${aws_lb.application.arn}"
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = "${aws_lb_target_group.application.arn}"
    }
}

resource "aws_lb_listener_rule" "application" {
    listener_arn = "${aws_lb_listener.application.arn}"
    priority     = 100

    action {
        type             = "forward"
        target_group_arn = "${aws_lb_target_group.application.arn}"
    }

    condition {
        path_pattern {
            values = ["/"]
        }
    }
}

# resource "aws_codedeploy_deployment_group" "application-deployment-grp" {
#     app_name              = "sre-terraform-app"
#     deployment_group_name = "application"
#     service_role_arn      = "arn:aws:iam::053769797169:role/codedeployrole"

#     deployment_style {
#         deployment_option = "WITH_TRAFFIC_CONTROL"
#         deployment_type = "IN_PLACE"
#     }

#     load_balancer_info {
       
#         target_group_info {
#             name = aws_lb_target_group.application.name
#         }
#     }

#     trigger_configuration {
#         trigger_events    = ["DeploymentFailure"]
#         trigger_name      = "On Failed Deployment"
#         trigger_target_arn= aws_sns_topic.sre_challenge.arn
#     }

#     auto_rollback_configuration {
#         enabled = false
#         events = ["DEPLOYMENT_FAILURE"]
#     }

#     autoscaling_groups    = ["${module.application.scaling_group_id}",
#                             ]
# }

# resource "aws_iam_role" "codedeploy-role" {
#   name = "codedeployrole"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#         {
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "codedeploy.amazonaws.com"
#             },
#             "Action": "sts:AssumeRole"
#         }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "codedeploy_policy" {
#   role = aws_iam_role.codedeploy-role.id
#   policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
# }

# resource "aws_iam_instance_profile" "codedeploy_instance_profile" {
#   name = "codedeploy_instance_profile"
#   role = aws_iam_role.codedeploy-role.name

#   depends_on = [ aws_iam_role.codedeploy-role ]
# }

# How to create a unique key pair for each host
# resource "tls_private_key" "sre-challenge" {
#   algorithm = "RSA"
#   rsa_bits = 4096
# }

# resource "aws_key_pair" "sre-challenge" {
#   key_name = var.key_name
#   public_key = tls_private_key.sre-challenge.public_key_openssh
# }

