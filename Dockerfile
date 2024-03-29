FROM golang:1.13.6-alpine3.10 as go

RUN apk --no-cache add build-base=0.5-r1

WORKDIR /src

COPY ./. .

ENV GO11MODULES 1
RUN unset GOPATH

RUN make build

FROM alpine:3.9 as main

COPY --from=go /src/bin/api-app /bin/api-app
