resource "aws_subnet" "first-pb-subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.first_pb_subnet_cidr
  availability_zone = var.first-AZ

  tags = {
    Name = "First-Public-Subnet"
  }
}

resource "aws_subnet" "second-pb-subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.second-pb-subnet-cidr
  availability_zone = var.Second-AZ
  tags = {
    Name = "Second-Public-Subnet"
  }
}
resource "aws_subnet" "third-pb-subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.third-pb-subnet-cidr
  availability_zone = var.third-AZ
  tags = {
    Name = "Third-Public-Subnet"
  }
}
resource "aws_subnet" "first-pv-subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.First-pv-subnet-cidr
  availability_zone = var.first-AZ
  tags = {
    Name = "First-PV-Subnet"
  }
}
resource "aws_subnet" "second-pv-subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.Second-pv-subnet-cidr
  availability_zone = var.Second-AZ   
  tags = {
    Name = "Second-PV-Subnet"
  }
}
resource "aws_subnet" "third-pv-subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.Third-pv-subnet-cidr
  availability_zone = var.third-AZ

  tags = {
    Name = "Main"
  }
}