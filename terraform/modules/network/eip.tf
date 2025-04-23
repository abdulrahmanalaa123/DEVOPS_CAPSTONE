resource "aws_eip" "nat_eip_1" {
    associate_with_private_ip = "PRIVATE_IP"
}

resource "aws_eip" "nat_eip_2" {
    associate_with_private_ip = "PRIVATE_IP"
}

resource "aws_eip" "nat_eip_3" {
    associate_with_private_ip = "PRIVATE_IP"
}
