FROM alpine:3.5

RUN apk update
RUN apk --no-cache add \
        bash \
        build-base \
        cmake \
        shadow
