
.PHONY: all build_packer inspect_terraform deploy_terraform taint_template


DOCKER_BUILDS = $(shell ls ./docker) 

all: build_docker_images build_packer deploy_terraform

build_packer:
	cd packer && \
	packer validate tlpr_ubuntu-18.04.json && \
	packer build tlpr_ubuntu-18.04.json

inspect_terraform:
	cd terraform && \
	terraform validate && \
	terraform plan

deploy_terraform: taint_template
	cd terraform && \
	terraform validate && \
	terraform apply -auto-approve

taint_template:
	cd terraform && \
	if terraform show |grep -q aws_launch_template.timeline_repo_ec2_launch_template; then \
	terraform taint aws_launch_template.timeline_repo_ec2_launch_template; fi


build_docker_images: $(DOCKER_BUILDS)
	

$(DOCKER_BUILDS):
	cd docker/$@ && \
	docker build -t mozillarelops/$@:latest .
	docker push mozillarelops/$@:latest


