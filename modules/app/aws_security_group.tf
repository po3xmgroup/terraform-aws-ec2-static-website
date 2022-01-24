resource "aws_security_group" "sgpo" {
  name        = "sgpo"
  description = "Allow SSH inbound traffic asdasd"
  vpc_id      = var.vpc_id
  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow traffic from TCP/80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    createdby = "po3xm"
    project   = "training"
    Name = "po3xm-sg"
  }
  
}