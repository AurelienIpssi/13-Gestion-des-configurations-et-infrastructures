data "aws_vpc" "this" {
  id = var.vpc_id
}

data "aws_internet_gateway" "this" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

module "subnet_1" {
  source = "../../infra/modules/subnet"

  username          = var.username
  environment       = var.environment
  vpc_id            = var.vpc_id
  cidr              = var.subnet_cidr
  availability_zone = var.availability_zone
  http_ingress_cidr = var.http_ingress_cidr
  admin_ip          = var.admin_ip
  tags              = var.tags
}

module "router_1" {
  source = "../../infra/modules/router"

  username           = var.username
  environment        = var.environment
  vpc_id             = var.vpc_id
  local_network_cidr = data.aws_vpc.this.cidr_block
  extra_network_cidr = "0.0.0.0/0"
  gateway_id         = data.aws_internet_gateway.this.id
  subnet_id          = module.subnet_1.sb_id
  tags               = var.tags
}

module "sg_1" {
  source = "../../infra/modules/security_group"

  username    = var.username
  environment = var.environment
  vpc_id      = var.vpc_id
  tags        = var.tags

  ingress_rules = [
    {
      name        = "http"
      description = "HTTP ingress"
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_blocks = var.http_ingress_cidr
    },
    {
      name        = "ssh"
      description = "SSH ingress"
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_blocks = [var.admin_ip]
    },
    {
      name        = "icmp"
      description = "ICMP ingress (ping)"
      protocol    = "icmp"
      from_port   = -1
      to_port     = -1
      cidr_blocks = [var.admin_ip]
    },
  ]
}

module "vm" {
  source = "../../infra/modules/compute"

  username      = var.username
  environment   = var.environment
  instance_ami  = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = module.subnet_1.sb_id
  sg_ids        = [module.sg_1.sg_id]
  public_key    = file(pathexpand("~/.ssh/terraform-ipssi.pub"))
  has_public_ip = var.has_public_ip
  tags          = var.tags
}
