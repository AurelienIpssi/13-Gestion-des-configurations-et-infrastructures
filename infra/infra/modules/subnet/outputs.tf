output "subnet_id" {
  value = aws_subnet.this.id
}

output "subnet_cidr" {
  value = aws_subnet.this.cidr_block
}

output "nacl_id" {
  value = aws_network_acl.this.id
}
