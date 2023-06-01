#AWS ELB Configuration
resource "aws_elb" "wwealb-elb" {
  name            = "wwealb-elb"
  subnets         = [aws_subnet.wwealbvpc-public-1.id, aws_subnet.wwealbvpc-public-2.id]
  security_groups = [aws_security_group.wwealb-elb-securitygroup.id]
  
  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 8080
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "wwealb-elb"
  }
}

#Security group for AWS ELB
resource "aws_security_group" "wwealb-elb-securitygroup" {
  vpc_id      = aws_vpc.wwealbvpc.id
  name        = "wwealb-elb-sg"
  description = "security group for Elastic Load Balancer"
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wwealb-elb-sg"
  }
}

#Security group for the Instances
resource "aws_security_group" "wwealb-instance" {
  vpc_id      = aws_vpc.wwealbvpc.id
  name        = "wwealb-instance"
  description = "security group for instances"
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.wwealb-elb-securitygroup.id]
  }

  tags = {
    Name = "wwealb-instance"
  }
}