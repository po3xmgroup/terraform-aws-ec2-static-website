resource "aws_subnet" "subnet" {
  # availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    createdby = "po3xm"
    project   = "training"
  }
}
