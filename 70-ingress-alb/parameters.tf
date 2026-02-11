resource "aws_ssm_parameter" "ingress-alb_listener_arn" {
  name  = "/${var.project}/${var.environment}/ingress-alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.ingress-alb.arn
}