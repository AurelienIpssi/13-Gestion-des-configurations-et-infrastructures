resource "aws_instance" "example" {
  ami           = "var.instance_ami"
  instance_type = "var.instance_type"
  subnet_id     = "var.subnet_id"
  key_name     = "var.key_name"
  vpc_security_group_ids = ["var.vpc_security_group_id"]

}
resource "aws_key_pair" "this_keypair" {
  key_name   = "var.key_name"
  public_key = "var.public_key"

}
