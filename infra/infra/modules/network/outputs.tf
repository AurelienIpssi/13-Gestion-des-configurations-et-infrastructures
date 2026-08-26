output "subnet_id" {
  value = aws_subnet.this.id
}

output "nacl_id" {
  value = aws_network_acl.this.id
}
