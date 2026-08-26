output "vm_public_ip" {
  value = module.compute.vm_public_ip
}

output "subnet_id" {
  value = module.subnet.subnet_id
}

output "sg_id" {
  value = module.security_group.sg_id
}

output "nacl_id" {
  value = module.subnet.nacl_id
}
