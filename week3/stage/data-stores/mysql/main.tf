resource "aws_db_subnet_group" "hyewon-dbsubnet" {
  name       = "hyewon-dbsubnetgroup"
  subnet_ids = [aws_subnet.hyewon-subnet3.id, aws_subnet.hyewon-subnet4.id]

  tags = {
    Name = "hyewon DB subnet group"
  }
}

resource "aws_db_instance" "hyewon-rds" {
  identifier_prefix      = "hyewon-t101"
  engine                 = "mysql"
  allocated_storage      = 10
  instance_class         = "db.t2.micro"
  db_subnet_group_name   = aws_db_subnet_group.hyewon-dbsubnet.name
  vpc_security_group_ids = [aws_security_group.hyewon-sg2.id]
  skip_final_snapshot    = true

  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
}