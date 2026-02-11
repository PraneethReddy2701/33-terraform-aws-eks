resource "aws_ssm_parameter" "ingress-alb_sg_id" {
  name  = "/${var.project}/${var.environment}/ingress-alb_sg_id"
  type  = "String"
  value = module.ingress-alb.sg_id
}

resource "aws_ssm_parameter" "bastion_sg_id" {
  name  = "/${var.project}/${var.environment}/bastion_sg_id"
  type  = "String"
  value = module.bastion.sg_id
}

resource "aws_ssm_parameter" "vpn_sg_id" {
  name  = "/${var.project}/${var.environment}/vpn_sg_id"
  type  = "String"
  value = module.vpn.sg_id
}

resource "aws_ssm_parameter" "eks-controlplane_sg_id" {
  name  = "/${var.project}/${var.environment}/eks-controlplane_sg_id"
  type  = "String"
  value = module.eks-controlplane.sg_id
}

resource "aws_ssm_parameter" "eks-node_sg_id" {
  name  = "/${var.project}/${var.environment}/eks-node_sg_id"
  type  = "String"
  value = module.eks-node.sg_id
}