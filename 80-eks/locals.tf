locals {
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  private_subnet_ids = split(",",data.aws_ssm_parameter.private_subnet_ids.value)
  eks-controlplane_sg_id = data.aws_ssm_parameter.eks-controlplane_sg_id.value
  eks-node_sg_id = data.aws_ssm_parameter.eks-node_sg_id.value

  common_tags = {
    Project = var.project
    Environment = var.environment
    Terraform = "true"
  }
}