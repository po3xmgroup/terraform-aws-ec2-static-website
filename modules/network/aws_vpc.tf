resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  enable_dns_hostnames = true
  tags = {
    createdby = "po3xm"
    project   = "training"
    Name = "po3xm-vpc"
  }
} 