#Dockerfile vars
python_version=3.9

#vars
IMAGENAME=ansible
REPO=besquared
IMAGEFULLNAME=${REPO}/${IMAGENAME}

.DEFAULT_GOAL := provision

.PHONY:	help build push provision shutdown get_ssh_hosts all

help:
	@echo "Makefile arguments:"
	@echo ""
	@echo "python_version - Python version"
	@echo ""
	@echo "Makefile commands:"
	@echo "build"
	@echo "push"
	@echo "all"

build:
	@docker build \
	--build-arg VARIANT="${python_version}" \
	--build-arg VCS_REF=`git rev-parse --short HEAD` \
	--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	-t ${IMAGEFULLNAME} .

push:
	@docker push ${IMAGEFULLNAME}

provision:
	@docker run \
	-it \
	--rm \
	--name ansible \
	--volume ${PWD}/provision:/provision \
	--volume ${HOME}/.ssh:/provision/.ssh \
	--workdir /provision \
	besquared/ansible \
	ansible all --user=pi -m ping

shutdown:
	@docker run \
	-it \
	--rm \
	--name ansible \
	--volume ${PWD}/provision:/provision \
	--volume ${HOME}/.ssh:/provision/.ssh \
	--workdir /provision \
	besquared/ansible \
	ansible all --user=pi --become --poll 0 -m shell -a "/sbin/shutdown -H 5 &"

get_ssh_host_keys:
	@docker run \
	-it \
	--rm \
	--name ansible \
	--volume ${PWD}/provision:/provision \
	--volume ${HOME}/.ssh:/provision/.ssh \
	--workdir /provision \
	besquared/ansible \
	ansible all --user=pi --ssh-extra-args="-o StrictHostKeyChecking=accept-new" -a true

all: build push