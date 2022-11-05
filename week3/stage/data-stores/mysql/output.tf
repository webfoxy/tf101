output "address" {
  value       = aws_db_instance.hyewon-rds.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = aws_db_instance.hyewon-rds.port
  description = "The port the database is listening on"
}

output "vpcid" {
  value       = aws_vpc.hyewon-vpc.id
  description = "hyewon VPC Id"
}