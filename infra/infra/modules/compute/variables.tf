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
