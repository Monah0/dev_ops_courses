# syntax=docker/dockerfile:1.4
FROM quay.io/projectquay/golang:1.20 AS builder

WORKDIR /app

# Копіюємо весь код проекту у контейнер
COPY . .

# Якщо проєкт використовує Go Modules, завантажуємо залежності
RUN go mod download

# Збираємо бінарник з правильними параметрами середовища
RUN GOOS=${TARGET_OS} GOARCH=${TARGET_ARCH} go build -o bin/app main.go

FROM alpine:latest
WORKDIR /root/

# Копіюємо бінарник із збірного образу
COPY --from=builder /app/bin/app .

CMD ["./app"]
