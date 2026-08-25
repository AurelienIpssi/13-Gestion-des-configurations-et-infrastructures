variable "username" {
type        = string
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
default     = "AMI of EC2 Instance"
#default     = ""
}
variable "instance_type" {
type        = string
}
variable "subnet_id" {
type        = string
}
variable "sg_ids" {
type        = list(string)
}
variable "key_name" {
type        = string
}
variable "public_key" {
type        = string
}
