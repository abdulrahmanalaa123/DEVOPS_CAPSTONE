output "vpc_id" {
    description = "VPC ID"
    value       = aws_vpc.main.id
}

output "private_subnet_ids" {
    description = "List of private subnet IDs"
    value       = [
        aws_subnet.first-pv-subnet.id,
        aws_subnet.second-pv-subnet.id,
        aws_subnet.third-pv-subnet.id
    ]
}

