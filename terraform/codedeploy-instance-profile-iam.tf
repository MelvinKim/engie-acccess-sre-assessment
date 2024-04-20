# resource "aws_iam_role" "codedeploy-role" {
#   name = "codedeployrole"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#         {
#             "Sid": "",
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "ec2.amazonaws.com"
#             },
#             "Action": "sts:AssumeRole"
#         }
#     ]
#   })
#   managed_policy_arns = [
#     "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
#   ]
# }