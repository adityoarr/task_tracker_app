# Build stage
FROM golang:1.26.4-alpine AS builder
# Install gcc dan musl-dev untuk kompilasi SQLite (CGO)
RUN apk add --no-cache gcc musl-dev
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
# Enable CGO untuk SQLite
RUN CGO_ENABLED=1 GOOS=linux go build -o main .

# Run stage
FROM alpine:latest
RUN apk add --no-cache ca-certificates
WORKDIR /app
COPY --from=builder /app/main .
# Menyiapkan volume untuk database.db agar data persisten
VOLUME ["/app"]
EXPOSE 8080
CMD ["./main"]