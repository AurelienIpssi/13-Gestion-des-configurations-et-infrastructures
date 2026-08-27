locals {
  prefix = "${var.username}-${var.environment}"
}

resource "aws_subnet" "this" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "${local.prefix}-subnet"
  }
}

# Defense in depth: a second, stateless firewall layer at the subnet boundary,
# independent of the security group attached to the instance's ENI.
resource "aws_network_acl" "this" {
  vpc_id     = var.vpc_id
  subnet_ids = [aws_subnet.this.id]

  tags = {
    Name = "${local.prefix}-nacl"
  }
}

resource "aws_network_acl_rule" "http_ingress" {
  for_each = { for idx, cidr in var.http_ingress_cidr : idx => cidr }

  network_acl_id = aws_network_acl.this.id
  rule_number    = 100 + tonumber(each.key)
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 80
  to_port        = 80
  cidr_block     = each.value
}

resource "aws_network_acl_rule" "ssh_ingress" {
  network_acl_id = aws_network_acl.this.id
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 22
  to_port        = 22
  cidr_block     = var.admin_ip
}

# NACLs are stateless: return traffic for outbound connections must be
# allowed in explicitly via the ephemeral port range.
# trivy:ignore:AWS-0105 deliberate: stateless return traffic for outbound connections can come back on any ephemeral port from any address
resource "aws_network_acl_rule" "ephemeral_ingress" {
  network_acl_id = aws_network_acl.this.id
  rule_number    = 300
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

# trivy:ignore:AWS-0102 deliberate: outbound traffic is not restricted, only inbound is (fail-safe default applies to ingress)
resource "aws_network_acl_rule" "all_egress" {
  network_acl_id = aws_network_acl.this.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  from_port      = 0
  to_port        = 0
  cidr_block     = "0.0.0.0/0"
}
