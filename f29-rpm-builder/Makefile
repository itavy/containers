ifdef CREDENTIALS_FILE
  include $(CREDENTIALS_FILE)
endif

include release_version.env

BUILD_DNS_SERVERS      ?=
GIT_CMD                ?= git

GIT_COMMIT_HASH        ?= $(word 1, $(shell $(GIT_CMD) rev-parse HEAD))
BUILD_VERSION          ?= 1.0.0
BUILD_TIME             ?= $(shell date +%FT%T%z)
BUILD_NUMBER           ?= 1

CONTAINER_CMD          ?= buildah
RUN_INSIDE_CONTAINER   ?= 0

PUBLISH_SERVER         ?= docker.io/library
PUBLISH_REPOSITORY     ?= itavy
PUBLISH_IMAGE          ?= f29-rpm-builder
PUBLISH_LATEST         ?= 1
PUBLISH_USERNAME       ?=
PUBLISH_PASSWORD       ?=

ifeq ($(PUBLISH_SERVER),docker.io/library)
CONTAINER_IMAGE         = $(PUBLISH_REPOSITORY)/$(PUBLISH_IMAGE)
else
CONTAINER_IMAGE         = $(PUBLISH_SERVER)/$(PUBLISH_REPOSITORY)/$(PUBLISH_IMAGE)
endif

IMAGE_TO_PUBLISH        = $(CONTAINER_IMAGE):$(BUILD_VERSION)

ifeq ($(PUBLISH_LATEST),1)
IMAGE_TO_PUBLISH_LATEST = $(CONTAINER_IMAGE):latest
endif

ifeq ($(RUN_INSIDE_CONTAINER),1)
ifeq ($(CONTAINER_CMD),buildah)
CONTAINER_CMD_OPTIONS   = --storage-driver vfs
endif
endif

BUILD_DETAILS = --tag $(IMAGE_TO_PUBLISH) \
				--build-arg GIT_COMMIT_HASH=$(GIT_COMMIT_HASH) \
				--build-arg BUILD_TIME=$(BUILD_TIME) \
				--build-arg DNS_SERVER="$(BUILD_DNS_SERVERS)" \
				--file Dockerfile \
				.

define buildah_push_image
$(CONTAINER_CMD) $(CONTAINER_CMD_OPTIONS) push \
--creds $(PUBLISH_USERNAME):$(PUBLISH_PASSWORD) \
$(1) \
docker://$(2)
endef

.PHONY: all
all: build publish

.PHONY: build
build:
ifeq ($(CONTAINER_CMD),buildah)
	$(CONTAINER_CMD) $(CONTAINER_CMD_OPTIONS) bud \
		$(BUILD_DETAILS)
else
	$(CONTAINER_CMD) $(CONTAINER_CMD_OPTIONS) build \
		$(BUILD_DETAILS)
endif


.PHONY: publish
publish: check-env
ifeq ($(CONTAINER_CMD),buildah)
	$(eval $@img_id := $(shell $(CONTAINER_CMD) $(CONTAINER_CMD_OPTIONS) images -q $(IMAGE_TO_PUBLISH)))

	$(call buildah_push_image,$($@img_id),$(IMAGE_TO_PUBLISH))

ifeq ($(PUBLISH_LATEST),1)
	$(CONTAINER_CMD) $(CONTAINER_CMD_OPTIONS) tag $(IMAGE_TO_PUBLISH) $(IMAGE_TO_PUBLISH_LATEST)
	$(call buildah_push_image,$($@img_id),$(IMAGE_TO_PUBLISH_LATEST))
endif
else
	$(CONTAINER_CMD) login \
		--username $(PUBLISH_USERNAME) \
		--password $(PUBLISH_PASSWORD) \
		$(PUBLISH_SERVER)

	$(CONTAINER_CMD) $(CONTAINER_CMD_OPTIONS) push $(IMAGE_TO_PUBLISH)

ifeq ($(PUBLISH_LATEST),1)
	$(CONTAINER_CMD) $(CONTAINER_CMD_OPTIONS) tag $(IMAGE_TO_PUBLISH) $(IMAGE_TO_PUBLISH_LATEST)
	$(CONTAINER_CMD) $(CONTAINER_CMD_OPTIONS) push $(IMAGE_TO_PUBLISH_LATEST)
endif

	$(CONTAINER_CMD) logout
endif

.PHONY: check-env
check-env:
	$(if $(value PUBLISH_USERNAME),, $(error Undefined PUBLISH_USERNAME))
	$(if $(value PUBLISH_PASSWORD),, $(error Undefined PUBLISH_PASSWORD))


ifeq ($(CONTAINER_CMD),buildah)
.PHONY: publish-local
publish-local:
	$(eval $@img_id := $(shell $(CONTAINER_CMD) $(CONTAINER_CMD_OPTIONS) images -q $(IMAGE_TO_PUBLISH)))

	$(CONTAINER_CMD) $(CONTAINER_CMD_OPTIONS) push \
    		$($@img_id) \
    		docker-daemon:$(IMAGE_TO_PUBLISH)
endif