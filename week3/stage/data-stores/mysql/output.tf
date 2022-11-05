output "address" {
  value       = aws_db_instance.webfoxy-rds.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = aws_db_instance.webfoxy-rds.port
  description = "The port the database is listening on"
}

output "vpcid" {
  value       = aws_vpc.webfoxy-vpc.id
  description = "webfoxy VPC Id"
}