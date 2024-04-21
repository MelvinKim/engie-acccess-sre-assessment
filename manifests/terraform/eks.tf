# provision eks cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name = local.cluster_name
  cluster_version = var.cluster_version
  vpc_id = var.vpc_id
  subnet_ids = var.subnet_ids
  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  eks_managed_node_groups = {
    one = {
      name = var.node_group_name
      instance_types = var.worker_nodes_instance_types
      min_size     = 1
      max_size     = 1
      desired_size = 1
    }
  }

  cluster_security_group_additional_rules = {
    nodeport_ingress = {
        type = "ingress"
        from_port = 30000
        to_port = 32767
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

# create cluster autoscaler IAM role - To allow cluster autoscaler to make API calls to AWS
resource "aws_iam_role" "cluster_autoscaler" {
  name = "cluster_autoscaler"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Action": [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ],
        "Resource": "*"
      }
    ]
  })
}

# create a cluster autoscaler
resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = "9.9.2"

  set {
    name  = "autoDiscovery.clusterName"
    value = local.cluster_name
  }

  set {
    name  = "awsRegion"
    value = var.region
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "rbac.serviceAccount.create"
    value = "true"
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.cluster_autoscaler_role_arn
  }
}