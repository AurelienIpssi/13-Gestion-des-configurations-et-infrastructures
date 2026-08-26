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

variable "vpc_cidr_block" {
  type    = string
  default = "192.168.0.0/16"

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.vpc_cidr_block))
    error_message = "vpc_cidr_block doit être un bloc CIDR valide, ex: 192.168.0.0/16."
  }
}

variable "vpc_id" {
  type        = string
  description = "VPC in which the subnet is created"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR block for the subnet"
}

variable "availability_zone" {
  type        = string
  description = "Availability zone for the subnet"
}

variable "http_ingress_cidr" {
  type        = list(string)
  description = "CIDR blocks allowed to reach HTTP (80) at the Network ACL (subnet) level"
  default     = ["0.0.0.0/0"]
}

variable "ssh_ingress_cidr" {
  type        = list(string)
  description = "CIDR blocks allowed to reach SSH (22) at the Network ACL (subnet) level. Fail-safe default: no default value, must be set explicitly."
}
