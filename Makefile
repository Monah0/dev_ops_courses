APP_NAME := app
IMAGE_TAG := quay.io/yourorg/$(APP_NAME)
PLATFORMS := linux/amd64 linux/arm64 darwin/amd64 darwin/arm64 windows/amd64

all: $(PLATFORMS)

define build_template
$(subst /,_,$(1)):
	docker buildx build \
		--platform=$(1) \
		--build-arg TARGET_OS=$(word 1,$(subst /, ,$(1))) \
		--build-arg TARGET_ARCH=$(word 2,$(subst /, ,$(1))) \
		--tag $(IMAGE_TAG):$(subst /,-,$(1)) \
		--output type=docker \
		.
endef

$(foreach plat,$(PLATFORMS),$(eval $(call build_template,$(plat))))

clean:
	$(foreach plat,$(PLATFORMS),docker rmi $(IMAGE_TAG):$(subst /,-,$(plat)) || true;)
