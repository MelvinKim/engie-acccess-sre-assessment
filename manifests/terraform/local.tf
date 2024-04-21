locals {
  cluster_name = "sre_assessment_cluster"
  vpc_name = "default-vpc"

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }
}