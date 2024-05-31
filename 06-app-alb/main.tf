#first step load balancer creation
resource "aws_lb" "app-alb" {
  name               = "${var.project_name}-${var.environment}-app-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.app_alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.private_subnet_ids.value) #for alb we are supposed to give min to subnets

  enable_deletion_protection = false

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-app-alb"
    }
  )
}


#second step listerner creation
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app-alb.arn
  port              = "80"
  protocol          = "HTTP"
  
  #if http certificates are not required =they are only for https
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>This is fixed response from APP ALB</h1>"
      status_code  = "200"
    }
  }
}

#route53 records for LB server
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name
  
  records = [
    {
      name    = "*.app-${var.environment}"
      type    = "A"
      allow_overwrite = true
      alias   = {
        name    = aws_lb.app-alb.dns_name
        zone_id = aws_lb.app-alb.zone_id
      }
    }
  ]
}