# security group for ingress-alb
module "ingress-alb" {
  source = "git::https://github.com/daws-84s/terraform-aws-securitygroup.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = var.ingress-alb_sg_name
  sg_description = var.ingress-alb_sg_description
  vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "ingress-alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.ingress-alb.sg_id
}


# security group for bastion host
module "bastion" {
  source = "git::https://github.com/PraneethReddy2701/16-terraform-aws-security-group-module.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name        = var.bastion_sg_name
  sg_description = var.bastion_sg_description
  vpc_id = local.vpc_id
}

# bastion accepting connections from laptop
resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}


# security group for vpn
module "vpn" {
  source = "git::https://github.com/PraneethReddy2701/16-terraform-aws-security-group-module.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name        = var.vpn_sg_name
  sg_description = var.vpn_sg_description
  vpc_id = local.vpc_id
}

# vpn server accepting connections from laptop (vpn client) on ports 22, 443, 1194, 943
# vpn ssh 22
resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

# vpn https 443
resource "aws_security_group_rule" "vpn_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

# vpn internal port 1194
resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

# vpn internal port 943
resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}


# security group for eks-controlplane
module "eks-controlplane" {
  source = "git::https://github.com/PraneethReddy2701/16-terraform-aws-security-group-module.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name        = var.eks-controlplane_sg_name
  sg_description = var.eks-controlplane_sg_description
  vpc_id = local.vpc_id
}

# eks-controlplane accepting all connections from eks-node
resource "aws_security_group_rule" "eks-controlplane_eks-node" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = module.eks-node.sg_id
  security_group_id = module.eks-controlplane.sg_id
}

# eks-controlplane accepting connections from bastion on port 443
resource "aws_security_group_rule" "eks-controlplane_bastion" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.eks-controlplane.sg_id
}


# security group for eks-node
module "eks-node" {
  source = "git::https://github.com/PraneethReddy2701/16-terraform-aws-security-group-module.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name        = var.eks-node_sg_name
  sg_description = var.eks-node_sg_description
  vpc_id = local.vpc_id
}

# eks-node accepting all connections from eks-controlplane
resource "aws_security_group_rule" "eks-node_eks-controlplane" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = module.eks-controlplane.sg_id
  security_group_id = module.eks-node.sg_id
}

# eks-node accepting connections from bastion
resource "aws_security_group_rule" "eks-node_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.eks-node.sg_id
}

# eks-node accepting connections from vpc
resource "aws_security_group_rule" "eks-node_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["10.0.0.0/16"]   # allowing eks nodes to allow traffic each other (for pod to pod communication if they are in different nodes) (vpc cidr)
  security_group_id = module.eks-node.sg_id
}