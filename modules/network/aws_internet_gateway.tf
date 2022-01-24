resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    createdby = "po3xm"
    project   = "training"
  }
}
