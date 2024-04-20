output "scaling_group_id" {
    value = "${aws_autoscaling_group.application.id}"
}

# output "generate_ssh_private_key" {
#   value = tls_private_key.sre-challenge.private_key_openssh
# }

# output "generate_ssh_publis_key" {
#   value = tls_private_key.sre-challenge.public_key_openssh
# }