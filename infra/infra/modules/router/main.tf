locals {
  prefix = "${var.username}-${var.environment}"
}

data "aws_internet_gateway" "this" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  # AWS creates this local route implicitly on every route table. Declaring
  # it here matches what AWS will create, so Terraform doesn't try to remove
  # it on every apply.
  route {
    cidr_block = var.vpc_cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.this.id
  }

  tags = {
    Name = "${local.prefix}-rt"
  }
}

resource "aws_route_table_association" "this" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.this.id
}
