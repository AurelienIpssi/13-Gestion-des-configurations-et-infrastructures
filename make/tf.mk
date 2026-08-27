INFRA_DIR:=	infra/

.PHONY:	tf.fmt.ci tf.fmt tf.init tf.lint tf.checkov
tf.fmt:
	@terraform -chdir="$(INFRA_DIR)" fmt -recursive -diff

tf.fmt.ci:
	@terraform -chdir="$(INFRA_DIR)" fmt -recursive -check

tf.init: ##terraform init for the current ENV
	@terraform -chdir="$(TF_ENV_DIR)" init -lock=false -input=false -upgrade

tf.lint: ##scan the terraform code for security misconfigurations (trivy)
	@trivy config "$(INFRA_DIR)"

tf.checkov: ##scan the terraform code for security misconfigurations (checkov, via Docker)
	@MSYS_NO_PATHCONV=1 docker run --rm -v "$(CURDIR)/infra:/tf" bridgecrew/checkov:latest -d /tf --compact --quiet
