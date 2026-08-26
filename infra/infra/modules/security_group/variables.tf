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

variable "http_ingress_cidr" {
  type        = list(string)
  description = "CIDR blocks allowed to reach HTTP (80). Public traffic, safe to leave open."
  default     = ["0.0.0.0/0"]
}

variable "ssh_ingress_cidr" {
  type        = list(string)
  description = "CIDR blocks allowed to reach SSH (22). Fail-safe default: no default value, must be set explicitly (e.g. your admin IP/32) rather than falling back to 0.0.0.0/0."
}
