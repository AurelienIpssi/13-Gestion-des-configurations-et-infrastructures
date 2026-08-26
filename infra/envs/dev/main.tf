module "network" {
  source = "../../infra/modules/network"

  username          = var.username
  environment       = var.environment
  vpc_id            = var.vpc_id
  subnet_cidr       = var.subnet_cidr
  availability_zone = var.availability_zone
  http_ingress_cidr = var.http_ingress_cidr
  ssh_ingress_cidr  = var.ssh_ingress_cidr
}

module "security_group" {
  source = "../../infra/modules/security_group"

  username          = var.username
  environment       = var.environment
  vpc_id            = var.vpc_id
  http_ingress_cidr = var.http_ingress_cidr
  ssh_ingress_cidr  = var.ssh_ingress_cidr
}

module "compute" {
  source = "../../infra/modules/compute"

  username      = var.username
  environment   = var.environment
  instance_ami  = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = module.network.subnet_id
  sg_ids        = [module.security_group.sg_id]
  key_name      = var.key_name
  public_key    = var.public_key
  has_public_ip = var.has_public_ip
}
