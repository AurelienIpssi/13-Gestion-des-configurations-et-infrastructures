#!/usr/bin/bash

set -eu -o pipefail

if [ ! -d ".git" ]; then
    git init
fi

{
    echo "*.tfvars"
    echo ".env"
    echo ".terraform"
    echo "*tfstate"
    echo "*tfstate.backup"
    echo "*.tfstate"
    echo "tfplan"
    echo "*tfplan"

}>>.gitignore

mkdir -p infra/envs/dev
cd infra/envs/dev
touch "main.tf" "variables.tf" "versions.tf" "outputs.tf" "providers.tf" "dev.aut.tfvars"
cd ../..
mkdir -p infra/modules
mkdir -p infra/modules/compute
mkdir -p infra/modules/security_group
mkdir -p infra/modules/network

for f in infra/modules/compute infra/modules/security_group infra/modules/network; do
  touch "$f/main.tf" "$f/variables.tf" "$f/versions.tf" "$f/outputs.tf"
done
