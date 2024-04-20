
resource "tls_private_key" "sre-challenge" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "sre-challenge" {
  key_name = var.key_name
  public_key = tls_private_key.sre-challenge.public_key_openssh
}