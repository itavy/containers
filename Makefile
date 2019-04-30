section ?= all

BUILD_DNS_SERVERS      ?=
GIT_CMD                ?= git

GIT_COMMIT_HASH        ?= $(word 1, $(shell $(GIT_CMD) rev-parse HEAD))
BUILD_VERSION          ?=
BUILD_TIME             ?= $(shell date +%FT%T%z)
BUILD_NUMBER           ?= 1

CONTAINER_CMD          ?= buildah
RUN_INSIDE_CONTAINER   ?= 0

PUBLISH_USERNAME       ?=
PUBLISH_PASSWORD       ?=

ALL_CONTAINERS = $(patsubst %/,%,$(sort $(dir $(wildcard */))))

.PHONY: all
all:
	$(error Please specify a target)

.EXPORT_ALL_VARIABLES:

.PHONY: $(ALL_CONTAINERS)
$(ALL_CONTAINERS): .EXPORT_ALL_VARIABLES
	$(MAKE) -C $@ $(section)
