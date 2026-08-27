locals {
  prefix = "${var.username}-${var.environment}"
}

resource "aws_key_pair" "vm_kp" {
  public_key = var.public_key
  key_name   = "${local.prefix}-key"
}

# checkov:skip=CKV2_AWS_41 no IAM role attached to this instance
resource "aws_instance" "this" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  key_name = aws_key_pair.vm_kp.key_name

  vpc_security_group_ids = var.sg_ids

  associate_public_ip_address = var.has_public_ip

  ebs_optimized = true
  monitoring    = true

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "${local.prefix}-vm"
  }
}
