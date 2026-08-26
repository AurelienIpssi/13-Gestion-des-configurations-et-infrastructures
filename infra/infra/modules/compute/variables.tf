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
variable "instance_ami" {
  type        = string
  description = "AMI ID for the EC2 instance"
}
variable "instance_type" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "sg_ids" {
  type = list(string)
}
variable "key_name" {
  type        = string
  description = "Name of an existing EC2 key pair (e.g. AWS Academy's pre-provisioned \"vockey\")"
}

variable "has_public_ip" {
  type    = bool
  default = true
}
