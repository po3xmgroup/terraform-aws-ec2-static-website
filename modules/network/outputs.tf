output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "igw_id" {
    value = aws_internet_gateway.igw.id
}

output "subnet_id" {
    value = aws_subnet.subnet.id
}