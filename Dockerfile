# syntax=docker/dockerfile:1.6

FROM quay.io/projectquay/golang:1.22 AS builder

WORKDIR /app

# Кеш залежностей
COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Build arguments from BuildKit
ARG TARGETOS
ARG TARGETARCH

# ВАЖЛИВО: крос-компіляція без емуляції
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go build -o app .

# Мінімальний runtime
FROM scratch

WORKDIR /root/

COPY --from=builder /app/app .

ENTRYPOINT ["./app"]
