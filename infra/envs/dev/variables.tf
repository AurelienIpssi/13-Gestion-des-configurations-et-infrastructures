variable "aws_region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "eu-west-3"
}

variable "username" {
  type        = string
  description = "Used as a resource-naming prefix"
}

variable "environment" {
  type        = string
  description = "dev, staging, production"
  default     = "dev"
}

variable "vpc_id" {
  type        = string
  description = "Existing VPC in which resources are created"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR block for the subnet"
}

variable "availability_zone" {
  type        = string
  description = "Availability zone for the subnet"
}

variable "instance_ami" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "Name of the EC2 key pair to create"
}

variable "public_key" {
  type        = string
  description = "SSH public key material for the EC2 key pair"
}

variable "has_public_ip" {
  type        = bool
  description = "Whether the instance gets a public IP"
  default     = true
}
