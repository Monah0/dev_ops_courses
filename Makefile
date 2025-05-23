IMAGE_NAME=quay.io/yourorg/app
PLATFORMS=linux/amd64,linux/arm64,darwin/amd64,darwin/arm64,windows/amd64

.PHONY: all clean build_linux_amd64 build_linux_arm64 build_darwin_amd64 build_darwin_arm64 build_windows_amd64 image

all: image

# Побудова образів для кожної платформи окремо
build_linux_amd64:
	docker buildx build --platform linux/amd64 --build-arg TARGET_OS=linux --build-arg TARGET_ARCH=amd64 -t $(IMAGE_NAME):linux-amd64 --load .

build_linux_arm64:
	docker buildx build --platform linux/arm64 --build-arg TARGET_OS=linux --build-arg TARGET_ARCH=arm64 -t $(IMAGE_NAME):linux-arm64 --load .

build_darwin_amd64:
	docker buildx build --platform darwin/amd64 --build-arg TARGET_OS=darwin --build-arg TARGET_ARCH=amd64 -t $(IMAGE_NAME):darwin-amd64 --load .

build_darwin_arm64:
	docker buildx build --platform darwin/arm64 --build-arg TARGET_OS=darwin --build-arg TARGET_ARCH=arm64 -t $(IMAGE_NAME):darwin-arm64 --load .

build_windows_amd64:
	docker buildx build --platform windows/amd64 --build-arg TARGET_OS=windows --build-arg TARGET_ARCH=amd64 -t $(IMAGE_NAME):windows-amd64 --load .

# Загальна задача для побудови всіх образів
image: build_linux_amd64 build_linux_arm64 build_darwin_amd64 build_darwin_arm64 build_windows_amd64

# Очищення локальних образів
clean:
	-docker rmi $(IMAGE_NAME):linux-amd64 || echo "Image not found: $(IMAGE_NAME):linux-amd64, skipping."
	-docker rmi $(IMAGE_NAME):linux-arm64 || echo "Image not found: $(IMAGE_NAME):linux-arm64, skipping."
	-docker rmi $(IMAGE_NAME):darwin-amd64 || echo "Image not found: $(IMAGE_NAME):darwin-amd64, skipping."
	-docker rmi $(IMAGE_NAME):darwin-arm64 || echo "Image not found: $(IMAGE_NAME):darwin-arm64, skipping."
	-docker rmi $(IMAGE_NAME):windows-amd64 || echo "Image not found: $(IMAGE_NAME):windows-amd64, skipping."
