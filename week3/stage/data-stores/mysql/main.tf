resource "aws_db_subnet_group" "webfoxy-dbsubnet" {
  name       = "webfoxy-dbsubnetgroup"
  subnet_ids = [aws_subnet.webfoxy-subnet3.id, aws_subnet.webfoxy-subnet4.id]

  tags = {
    Name = "webfoxy DB subnet group"
  }
}

resource "aws_db_instance" "webfoxy-rds" {
  identifier_prefix      = "webfoxy-t101"
  engine                 = "mysql"
  allocated_storage      = 10
  instance_class         = "db.t2.micro"
  db_subnet_group_name   = aws_db_subnet_group.webfoxy-dbsubnet.name
  vpc_security_group_ids = [aws_security_group.webfoxy-sg2.id]
  skip_final_snapshot    = true

  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
}