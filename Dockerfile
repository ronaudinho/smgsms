# FROM golang:1.13-alpine AS build
FROM golang:1.13-alpine
RUN apk add --no-cache ca-certificates && update-ca-certificates
# RUN mkdir /app/
# COPY main.go .
# COPY go.mod .
# COPY go.sum .
COPY smgsms.jpg .
COPY smgsms.mp3 .
COPY smgsms .
# RUN CGO_ENABLED=1 GOOS=linux go build -a -installsuffix cgo -ldflags '-linkmode external -extldflags'

WORKDIR /
# FROM scratch
# COPY --from=build /app/ /
# COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./smgsms"]
LABEL Name=smgsms Version=0.1.0
EXPOSE 3195
