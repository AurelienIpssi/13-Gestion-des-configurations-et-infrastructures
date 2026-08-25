resource "aws_instance" "example" {
  ami           = "var.instance_ami"
  instance_type = "var.instance_type"
  subnet_id     = "var.subnet_id"
  key_name     = "var.key_name"
  vpc_security_group_ids = ["var.vpc_security_group_id"]

}
