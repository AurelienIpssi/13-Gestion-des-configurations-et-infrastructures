locals {
  prefix = "${var.username}-${var.environment}"
}

resource "aws_security_group" "this" {
  # Ensure that Security Groups are attached to another resource
  # checkov:skip=CKV2_AWS_5:attached to the compute module's instance via sg_ids
  name        = "${local.prefix}-sg"
  description = "Security Group to allow http and ssh for only for admin"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${local.prefix}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  for_each = toset(var.http_ingress_cidr)

  security_group_id = aws_security_group.this.id
  description       = "HTTP ingress"
  # Ensure no security groups allow ingress from 0.0.0.0:0 to port 80
  # checkov:skip=CKV_AWS_260:intentionally public HTTP
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = each.value

  tags = {
    Name = "${local.prefix}-sg-in-rule-allow-http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.this.id
  description       = "SSH ingress"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.admin_ip

  tags = {
    Name = "${local.prefix}-sg-in-rule-allow-admin-ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "icmp" {
  security_group_id = aws_security_group.this.id
  description       = "ICMP ingress (ping)"
  ip_protocol       = "icmp"
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = var.admin_ip

  tags = {
    Name = "${local.prefix}-sg-in-rule-allow-admin-icmp"
  }
}

# AWS auto-creates an allow-all egress rule at the API level, but Terraform's
# aws_security_group removes it when no egress rule is declared, so it is
# spelled out explicitly here rather than relied upon implicitly.
# trivy:ignore:AWS-0104 deliberate: outbound traffic is not restricted, only inbound is (fail-safe default applies to ingress)
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${local.prefix}-sg-eg-rule-all-outbound"
  }
}
