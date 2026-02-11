variable "project" {
  default = "roboshop"  
}

variable "environment" {
  default = "dev" 
}

variable "sg_tags"{
  type = map(string)
  default = {}
}

variable "ingress-alb_sg_name" {
  default = "ingress-alb"
}

variable "ingress-alb_sg_description" {
  default = "this security group is created for ingress-alb"  
}

variable "bastion_sg_name" {
  default = "bastion"
}

variable "bastion_sg_description" {
  default = "this security group is created for bastion"  
}

variable "vpn_sg_name" {
  default = "vpn"
}

variable "vpn_sg_description" {
  default = "this security group is created for vpn"  
}

variable "eks-controlplane_sg_name" {
  default = "eks-controlplane"
}

variable "eks-controlplane_sg_description" {
  default = "this security group is created for eks-controlplane"  
}

variable "eks-node_sg_name" {
  default = "eks-node"
}

variable "eks-node_sg_description" {
  default = "this security group is created for eks-node"  
}




