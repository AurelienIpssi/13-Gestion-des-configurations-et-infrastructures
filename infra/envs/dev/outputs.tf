output "vm_public_ip" {
  value = module.compute.vm_public_ip
}

output "subnet_id" {
  value = module.network.subnet_id
}

output "sg_id" {
  value = module.security_group.sg_id
}
