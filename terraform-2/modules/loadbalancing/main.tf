resource "aws_lb" "tier_lb" {
  name = "tier_lb"
  security_groups = [ var.lb_sg ]
  subnets = var.public_subnets
  idle_timeout = 400
  depends_on = [ var.app_sg ]
}

resource "aws_lb_target_group" "tier_tg" {
    name = "tier_lb-tg"
    port =  var.port
    protocol = var.protocol
    vpc_id = var.vpc_id

    lifecycle {
      ignore_changes = [ name ]
      create_before_destroy = true
    }
}

resource "aws_lb_listener" "tier_lb" {
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.tier_lb.arn
    }
  load_balancer_arn = aws_lb.tier_lb.arn
}