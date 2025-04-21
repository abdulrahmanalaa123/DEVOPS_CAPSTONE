# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cider
  
  tags = {
    Name = "MyVPC"
  }
}
