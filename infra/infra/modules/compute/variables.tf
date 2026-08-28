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
variable "public_key" {
  type        = string
  description = "SSH public key material for the EC2 key pair"
}

variable "has_public_ip" {
  type    = bool
  default = false # fail-safe default
}

variable "iam_instance_profile_name" {
  type        = string
  default     = "LabInstanceProfile"
  description = "Existing IAM instance profile to attach (AWS Academy pre-provisions this one)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags merged into every resource's tags, e.g. { Project = \"...\", Owner = \"...\" }"
}
