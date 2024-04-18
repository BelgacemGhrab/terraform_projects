resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  
  tags = {
    Name = "${var.project_name} ALB security group"
  }
}

resource "aws_lb" "alb" {

    name               = "${var.project_name}-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [ aws_security_group.alb_sg.id ]
    subnets            = var.public_subnets_ids 

    tags = {
        Name = "${var.project_name} ALB"
    }
}

resource "aws_lb_target_group" "alb_target_group" {

    name     = "alb-target-group"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id
    
    tags = {
        Name = "${var.project_name} ALB target group"
    }
}

resource "aws_lb_listener" "alb_listener" {

    load_balancer_arn = aws_lb.alb.arn
    port              = 80
    protocol          = "HTTP"
    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.alb_target_group.arn
    } 

    tags = {
        Name = "${var.project_name} ALB Listener"
    }
  
}