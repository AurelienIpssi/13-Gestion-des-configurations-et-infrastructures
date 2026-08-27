output "vm_public_ip" {
  value = module.vm.vm_public_ip
}

output "subnet_id" {
  value = module.subnet_1.sb_id
}

output "sg_id" {
  value = module.sg_1.sg_id
}

output "nacl_id" {
  value = module.subnet_1.nacl_id
}

output "subnet_cidr" {
  value = module.subnet_1.sb_cidr
}

output "route_table_id" {
  value = module.router_1.route_table_id
}
