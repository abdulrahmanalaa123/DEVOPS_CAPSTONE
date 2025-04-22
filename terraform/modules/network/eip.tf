resource "aws_eip" "nat_eip_1" {
    vpc = true
}

resource "aws_eip" "nat_eip_2" {
  vpc = true
}

resource "aws_eip" "nat_eip_3" {
  vpc = true
}
