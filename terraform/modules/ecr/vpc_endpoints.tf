resource "aws_vpc_endpoint" "ecr" {
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.${var.region}.ecr"
}
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.${var.region}.ecr"
}
