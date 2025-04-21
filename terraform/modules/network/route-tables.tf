resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.first-pb-subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.second-pb-subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.third-pb-subnet.id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table" "public-pv1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.First-NAT.id
  }

  tags = {
    Name = "priv-rt"
  }
}

resource "aws_route_table_association" "pv-a" {
  subnet_id      = aws_subnet.first-pv-subnet.id
  route_table_id = aws_route_table.public-pv1.id
}


resource "aws_route_table" "public-pv2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Second-NAT.id
  }

  tags = {
    Name = "priv-rt2"
  }
}

resource "aws_route_table_association" "pv-b" {
  subnet_id      = aws_subnet.second-pv-subnet.id
  route_table_id = aws_route_table.public-pv2.id
}

resource "aws_route_table" "public-pv3" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.third-nat.id
  }

  tags = {
    Name = "priv-rt3"
  }
}

resource "aws_route_table_association" "pv-c" {
  subnet_id      = aws_subnet.third-pv-subnet.id
  route_table_id = aws_route_table.public-pv3.id
}