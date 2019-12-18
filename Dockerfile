FROM golang:1.13-alpine AS build
RUN apk add --no-cache ca-certificates && update-ca-certificates
RUN mkdir /app/
WORKDIR /app/
COPY smgsms.mp3 .
COPY smgsms .

FROM scratch
COPY --from=build /app/ /
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./smgsms"]
LABEL Name=smgsms Version=0.1.0
EXPOSE 49389
