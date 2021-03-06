output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_public_subnet_ids" {
  value = [
    for subnet in aws_subnet.public : subnet.id
  ]
}

output "vpc_private_subnet_ids" {
  value = [
    for subnet in aws_subnet.private : subnet.id
  ]
}