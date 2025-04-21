resource "aws_nat_gateway" "First-NAT" {
  subnet_id     = aws_subnet.first-pb-subnet.id
  allocation_id = aws_eip.nat_eip_1.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "Second-NAT" {
  subnet_id     = aws_subnet.second-pb-subnet.id
  allocation_id = aws_eip.nat_eip_2.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "third-nat"  {
  subnet_id     = aws_subnet.third-pb-subnet.id
  allocation_id = aws_eip.nat_eip_3.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}