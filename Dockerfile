# syntax=docker/dockerfile:1.4
FROM quay.io/projectquay/golang:1.20 as builder

WORKDIR /app
COPY . .

# Збірка залежно від змінних середовища
RUN GOOS=${TARGET_OS} GOARCH=${TARGET_ARCH} go build -o bin/app main.go

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/bin/app .

CMD ["./app"]
