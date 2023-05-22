########################################
##  Stage 1
########################################

FROM golang:1.19-alpine3.18 as builder

RUN apk update && apk upgrade && \
    apk add --no-cache git make

# setup the working directory
WORKDIR /go/src/predixy_exporter
COPY . .

# -d flag, download the package
# -v flag, enables verbose progress and debug output
RUN go get -d -v ./...

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 make

########################################
##  Stage 2
########################################

FROM ubuntu:bionic-20230412

COPY --from=builder /go/src/predixy_exporter/predixy_exporter /usr/local/bin/predixy_exporter

ENTRYPOINT ["/usr/local/bin/predixy_exporter"]

# ecr path xxxx.amazonaws.com/zomato/predixy_exporter:v1