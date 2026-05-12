APP_NAME=app
IMAGE_NAME=quay.io/monah0/app

PLATFORMS=linux/amd64 linux/arm64 darwin/arm64 windows/amd64

build:
	docker buildx build --platform $(PLATFORMS) -t $(IMAGE_NAME):latest .

linux:
	GOOS=linux GOARCH=amd64 go build -o bin/$(APP_NAME)-linux-amd64

arm:
	GOOS=linux GOARCH=arm64 go build -o bin/$(APP_NAME)-linux-arm64

mac:
	GOOS=darwin GOARCH=arm64 go build -o bin/$(APP_NAME)-mac-arm64

windows:
	GOOS=windows GOARCH=amd64 go build -o bin/$(APP_NAME)-windows-amd64.exe

test-linux:
	docker buildx build --platform linux/amd64 -t $(IMAGE_NAME):linux --load .
	docker run --rm $(IMAGE_NAME):linux

test-arm:
	docker buildx build --platform linux/arm64 -t $(IMAGE_NAME):arm --load .
	docker run --rm $(IMAGE_NAME):arm

push:
	docker buildx build \
		--platform $(PLATFORMS) \
		-t $(IMAGE_NAME):latest \
		--push .
