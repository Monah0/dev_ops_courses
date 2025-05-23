APP_NAME := app
IMAGE_TAG := quay.io/yourorg/$(APP_NAME)
PLATFORMS := linux/amd64 linux/arm64 darwin/amd64 darwin/arm64 windows/amd64

# Очищення локальних образів, якщо вони існують
clean:
	@$(foreach plat, $(PLATFORMS), \
		tag=$(subst /,-,$(plat)); \
		if docker image inspect $(IMAGE_TAG):$$tag > /dev/null 2>&1; then \
			echo "Removing image: $(IMAGE_TAG):$$tag"; \
			docker rmi $(IMAGE_TAG):$$tag; \
		else \
			echo "Image not found: $(IMAGE_TAG):$$tag, skipping."; \
		fi;)

# Шаблон для збірки образів
define build_template
$(subst /,_,$(1)):
	docker buildx build \
    --platform=$(1) \
    --build-arg TARGET_OS=$(word 1,$(subst /, ,$(1))) \
    --build-arg TARGET_ARCH=$(word 2,$(subst /, ,$(1))) \
    --tag $(IMAGE_TAG):$(subst /,-,$(1)) \
    --load \
    .
		.
endef

# Генерація правил збірки
$(foreach plat,$(PLATFORMS),$(eval $(call build_template,$(plat))))

# Збірка всіх образів
all: $(foreach plat,$(PLATFORMS),$(subst /,_,$(plat)))

# Псевдоціль для зручності
image: all
