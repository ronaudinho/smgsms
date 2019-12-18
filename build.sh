#!/bin/bash -e
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"'
docker build -t smgsms .
