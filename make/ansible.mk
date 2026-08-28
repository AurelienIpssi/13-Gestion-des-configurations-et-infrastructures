ANSIBLE_DIR:=	$(CURDIR)/iac-mastere-4a/03-ansible
WSL_DISTRO:=	Ubuntu

.PHONY:	ansible.inventory ansible.run build
ansible.inventory: ##generate the Ansible inventory from the current Terraform outputs
	@bash scripts/generate-inventory.sh "$(TF_ENV_DIR)" "$(ANSIBLE_DIR)/inventory.ini"

ansible.run: ##run the Ansible playbook against the generated inventory (via WSL)
	@drive=$$(echo "$(ANSIBLE_DIR)" | cut -c1 | tr 'A-Z' 'a-z'); \
	wsl_dir="/mnt/$${drive}$$(echo "$(ANSIBLE_DIR)" | cut -c3-)"; \
	wsl -d $(WSL_DISTRO) -- bash -lc "cd \"$$wsl_dir\" && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbook.yaml"

build: tf.apply ansible.inventory ansible.run ##terraform apply -> generate Ansible inventory -> run the playbook, end to end
