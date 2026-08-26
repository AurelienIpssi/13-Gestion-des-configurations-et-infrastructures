INFRA_DIR:=	infra/

.PHONY:	tf.fmt.ci tf.fmt tf.init
tf.fmt:
	@terraform -chdir=$(INFRA_DIR) fmt -recursive -diff

tf.fmt.ci:
	@terraform -chdir=$(INFRA_DIR) fmt -recursive -check

tf.init: ##terraform init for the current ENV
	@terraform -chdir=$(TF_ENV_DIR) init -lock=false -input=false -upgrade
