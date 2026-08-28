locals {
  prefix = "${var.username}-${var.environment}"
}

resource "aws_key_pair" "vm_kp" {
  public_key = var.public_key
  key_name   = "${local.prefix}-key"
}

# AWS Academy pre-provisions this instance profile; students can't create
# their own IAM roles, so it is reused instead of a dedicated role.
data "aws_iam_instance_profile" "lab" {
  name = var.iam_instance_profile_name
}

resource "aws_instance" "this" {
  # checkov:skip=CKV_AWS_88:public IP needed to reach the instance directly for this exercise; opt-in via has_public_ip (default false)
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  key_name = aws_key_pair.vm_kp.key_name

  iam_instance_profile = data.aws_iam_instance_profile.lab.name

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

  tags = merge(var.tags, {
    Name = "${local.prefix}-vm"
  })
}
