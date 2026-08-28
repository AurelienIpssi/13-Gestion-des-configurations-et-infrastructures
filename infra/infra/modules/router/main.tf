locals {
  prefix = "${var.username}-${var.environment}"
}

resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  # AWS creates this local route implicitly on every route table. Declaring
  # it here matches what AWS will create, so Terraform doesn't try to remove
  # it on every apply.
  route {
    cidr_block = var.local_network_cidr
    gateway_id = "local"
  }

  route {
    cidr_block = var.extra_network_cidr
    gateway_id = var.gateway_id
  }

  tags = merge(var.tags, {
    Name = "${local.prefix}-route-table"
  })
}

resource "aws_route_table_association" "this" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.this.id
}
