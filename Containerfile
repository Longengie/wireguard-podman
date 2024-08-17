# syntax=docker/dockerfile:1
# Pull the official Alpine image of Docker from Docker Hub
FROM --platform=$BUILDPLATFORM docker.io/alpine:3.20.2

# set Version label
ARG BUILD_DATE
ARG VERSION
ARG WIREGUARD_RELEASE

LABEL "website.name"="longengie.com"
LABEL build_version="Longengie.com version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="longengie"

COPY ./scripts/run.sh .

# Install dependencies for Wireguard and Wireguard
RUN sh ./run.sh

RUN rm ./run.sh

COPY /root /

EXPOSE 51820/udp
