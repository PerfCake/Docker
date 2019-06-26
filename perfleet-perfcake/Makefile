IMAGE_NAME = quay.io/pmacik/perfleet-perfcake
IMAGE_TAG ?= :latest
LOCAL_IMAGE_NAME = perfleet-perfcake

CONTAINER_ENGINE := docker

.PHONY: build-tools
build-tools:
	${CONTAINER_ENGINE} build -t $(LOCAL_IMAGE_NAME)-tools:latest -f Dockerfile.tools .

.PHONY: build
build: build-tools
	${CONTAINER_ENGINE} build -t $(LOCAL_IMAGE_NAME)-build:latest -f Dockerfile.build .

.PHONY: build-deploy
build-deploy: build
	s2i build . $(LOCAL_IMAGE_NAME)-build:latest $(IMAGE_NAME)$(IMAGE_TAG)

#.PHONY: clean
#clean:
#	${CONTAINER_ENGINE} rmi -f $(LOCAL_IMAGE_NAME)-tools:latest $(LOCAL_IMAGE_NAME)-build $(IMAGE_NAME)$(IMAGE_TAG)