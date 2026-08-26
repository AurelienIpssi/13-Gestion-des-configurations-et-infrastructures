module "subnet_1" {
  source = "../../infra/modules/subnet"

  username          = var.username
  environment       = var.environment
  vpc_id            = var.vpc_id
  cidr              = var.subnet_cidr
  availability_zone = var.availability_zone
  http_ingress_cidr = var.http_ingress_cidr
  admin_ip          = var.admin_ip
}

module "sg_1" {
  source = "../../infra/modules/security_group"

  username          = var.username
  environment       = var.environment
  vpc_id            = var.vpc_id
  http_ingress_cidr = var.http_ingress_cidr
  admin_ip          = var.admin_ip
}

module "vm" {
  source = "../../infra/modules/compute"

  username      = var.username
  environment   = var.environment
  instance_ami  = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = module.subnet_1.subnet_id
  sg_ids        = [module.sg_1.sg_id]
  key_name      = var.key_name
  has_public_ip = var.has_public_ip
}
