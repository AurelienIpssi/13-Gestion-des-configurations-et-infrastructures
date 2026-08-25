INFRA_DIR:=	infra/

.PHONY:	tf.fmt.ci tf.fmt
tf.fmt:
	@Terraform -chdir=$(INFRA_DIR) fmt -recursive -diff

tf.fmt.ci:
	@Terraform -chdir=$(INFRA_DIR) fmt -recursive -check
