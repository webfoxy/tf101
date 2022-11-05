terraform {
  backend "s3" {
    bucket = "webfoxy-t101study-tfstate-week3-files"
    key    = "stage/services/webserver-cluster/terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "webfoxy-terraform-locks-week3-files"
  }
}

provider "aws" {
  region  = "ap-northeast-2"
}

data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = "webfoxy-t101study-tfstate-week3-files"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

resource "aws_subnet" "webfoxy-subnet1" {
  vpc_id     = data.terraform_remote_state.db.outputs.vpcid
  cidr_block = "10.10.1.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "webfoxy-t101-subnet1"
  }
}

resource "aws_subnet" "webfoxy-subnet2" {
  vpc_id     = data.terraform_remote_state.db.outputs.vpcid
  cidr_block = "10.10.2.0/24"

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "webfoxy-t101-subnet2"
  }
}

resource "aws_internet_gateway" "webfoxy-igw" {
  vpc_id = data.terraform_remote_state.db.outputs.vpcid

  tags = {
    Name = "webfoxy-t101-igw"
  }
}

resource "aws_route_table" "webfoxy-rt" {
  vpc_id = data.terraform_remote_state.db.outputs.vpcid

  tags = {
    Name = "webfoxy-t101-rt"
  }
}

resource "aws_route_table_association" "webfoxy-rtassociation1" {
  subnet_id      = aws_subnet.webfoxy-subnet1.id
  route_table_id = aws_route_table.webfoxy-rt.id
}

resource "aws_route_table_association" "webfoxy-rtassociation2" {
  subnet_id      = aws_subnet.webfoxy-subnet2.id
  route_table_id = aws_route_table.webfoxy-rt.id
}

resource "aws_route" "webfoxy-defaultroute" {
  route_table_id         = aws_route_table.webfoxy-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.webfoxy-igw.id
}

resource "aws_security_group" "mysg" {
  vpc_id      = data.terraform_remote_state.db.outputs.vpcid
  name        = "webfoxy T101 SG"
  description = "T101 Study SG"
}

resource "aws_security_group_rule" "webfoxy-sginbound" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.webfoxy-sg.id
}

resource "aws_security_group_rule" "webfoxy-sgoutbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.webfoxy-sg.id
}