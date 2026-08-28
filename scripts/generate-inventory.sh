#!/usr/bin/env bash
set -euo pipefail

# Generates the Ansible inventory from the current Terraform state/outputs.
# Usage: generate-inventory.sh <tf_env_dir> <inventory_file>

tf_env_dir="$1"
inventory_file="$2"

vm_ip=$(terraform -chdir="$tf_env_dir" output -raw vm_public_ip)

cat > "$inventory_file" <<EOF
[dev]
$vm_ip ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/terraform-ipssi
EOF

echo "generated $inventory_file (dev -> $vm_ip)"
