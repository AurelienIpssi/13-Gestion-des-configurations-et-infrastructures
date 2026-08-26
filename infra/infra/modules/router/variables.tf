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
  description = "VPC the route table belongs to"
}

variable "local_network_cidr" {
  type        = string
  description = "The VPC's own CIDR block, for the local route AWS creates implicitly on every route table"
}

variable "extra_network_cidr" {
  type        = string
  description = "CIDR to route out through the gateway, e.g. 0.0.0.0/0 for internet access"
}

variable "gateway_id" {
  type        = string
  description = "Gateway (e.g. internet gateway) the extra_network_cidr route points to"
}

variable "subnet_id" {
  type        = string
  description = "Subnet to associate with this route table"
}
