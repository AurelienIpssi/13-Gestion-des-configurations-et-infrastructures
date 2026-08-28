variable "username" {
  type = string
}

variable "environment" {
  type        = string
  description = "dev, staging, production"
  validation {
    condition     = can(regex("^[a-z]+$", var.environment))
    error_message = "Environment must contain only lowercase letters."
  }
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be one of: dev, staging, production."
  }
}

variable "vpc_id" {
  type        = string
  description = "VPC in which the security group is created"
}

variable "ingress_rules" {
  type = list(object({
    name        = string
    description = string
    protocol    = string # "tcp", "udp", "icmp"
    from_port   = number # for icmp: type (-1 = all)
    to_port     = number # for icmp: code (-1 = all)
    cidr_blocks = list(string)
  }))
  description = "Ingress rules to allow on the security group, one aws_vpc_security_group_ingress_rule per (rule, cidr) pair"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags merged into every resource's tags, e.g. { Project = \"...\", Owner = \"...\" }"
}
