locals {
  prefix = "${var.username}-${var.environment}"

  # Expand each rule's cidr_blocks list into one (rule, cidr) pair per entry,
  # so a single dynamic resource can create one ingress rule per pair.
  ingress_rule_cidrs = flatten([
    for rule in var.ingress_rules : [
      for cidr in rule.cidr_blocks : {
        key         = "${rule.name}-${cidr}"
        description = rule.description
        protocol    = rule.protocol
        from_port   = rule.from_port
        to_port     = rule.to_port
        cidr        = cidr
      }
    ]
  ])
}

resource "aws_security_group" "this" {
  # Ensure that Security Groups are attached to another resource
  # checkov:skip=CKV2_AWS_5:attached to the compute module's instance via sg_ids
  name        = "${local.prefix}-sg"
  description = "Security Group to allow http and ssh for only for admin"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${local.prefix}-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = { for r in local.ingress_rule_cidrs : r.key => r }

  security_group_id = aws_security_group.this.id
  description       = each.value.description
  # Ensure no security groups allow ingress from 0.0.0.0:0 to port 80
  # checkov:skip=CKV_AWS_260:intentionally public HTTP
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol
  cidr_ipv4   = each.value.cidr

  tags = merge(var.tags, {
    Name = "${local.prefix}-sg-in-rule-${each.value.key}"
  })
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

  tags = merge(var.tags, {
    Name = "${local.prefix}-sg-eg-rule-all-outbound"
  })
}
