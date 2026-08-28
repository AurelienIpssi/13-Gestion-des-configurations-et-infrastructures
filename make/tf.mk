INFRA_DIR:=	infra/

.PHONY:	tf.fmt.ci tf.fmt tf.init tf.lint tf.scan tf.apply
tf.fmt:
	@terraform -chdir="$(INFRA_DIR)" fmt -recursive -diff

tf.fmt.ci:
	@terraform -chdir="$(INFRA_DIR)" fmt -recursive -check

tf.init: ##terraform init for the current ENV
	@terraform -chdir="$(TF_ENV_DIR)" init -lock=false -input=false -upgrade

tf.apply: ##terraform apply for the current ENV (auto-approve)
	@terraform -chdir="$(TF_ENV_DIR)" apply -lock=false -input=false -auto-approve

tf.lint: ##scan the terraform code for security misconfigurations (trivy)
	@trivy config "$(INFRA_DIR)"

tf.scan: ##scan the terraform code for security misconfigurations (checkov, via Docker) and print the VM's public IP
	@MSYS_NO_PATHCONV=1 docker run --rm -v "$(CURDIR)/infra:/tf" bridgecrew/checkov:latest -d /tf --compact --quiet || true; \
	echo "vm_public_ip = $$(terraform -chdir="$(TF_ENV_DIR)" output -raw vm_public_ip 2>/dev/null)"
