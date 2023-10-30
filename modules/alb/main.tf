resource "aws_lb" "this" {
  name                       = var.name
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = false
  subnets                    = var.subnets
  security_groups            = var.alb_security_groups
}

resource "aws_lb_target_group" "this" {
  name     = "${var.name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group" "application" {
  name     = "${var.name}-tg-app"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "application" {
  load_balancer_arn = aws_lb.this.arn
  port              = 3000
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
