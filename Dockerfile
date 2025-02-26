FROM golang:1.17-alpine as builder

WORKDIR /workspace

COPY go.mod go.sum /workspace/
RUN go mod download

COPY main.go main.go
COPY action.go action.go

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o action

# ---------------
FROM gcr.io/distroless/static:latest

LABEL org.opencontainers.image.source=https://github.com/rode/create-build-occurrence-action

COPY --from=builder /workspace/action /usr/local/bin/action

ENTRYPOINT ["action"]
