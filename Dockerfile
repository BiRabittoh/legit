FROM golang:alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download
RUN go mod verify

COPY *.go ./
COPY config ./config
COPY git ./git
COPY routes ./routes
RUN go build -o legit

FROM scratch

WORKDIR /app

COPY static ./static
COPY templates ./templates
COPY config.yaml ./
COPY --from=builder /app/legit ./

EXPOSE 5555

CMD ["./legit"]
