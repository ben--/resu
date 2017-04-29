# resu [![Build Status](https://travis-ci.org/ben--/resu.svg?branch=master)](https://travis-ci.org/ben--/resu)

Minimal, safe solution for running docker processes as a non-root user.

Typically used with `tini` (see below) to provide a well-managed environment for running applications or scripts within docker.  `tini` provides process management and `resu` performs the privilege reduction.

The combination can be used for safer server management or to ensure created files in mounted volumes are owned by the correct user.  (As when using mkdo to create build environments.)

## Usage

First, instrument your favorite, minimalist docker image by installing `tini` and `resu` and using them as your Docker's entrypoint:

```Dockerfile
FROM debian:8.5

ENV TINI_VERSION v0.9.0
ENV RESU_VERSION 0.1.1

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /sbin/tini
ADD https://github.com/ben--/resu/releases/download/${RESU_VERSION}/resu /sbin/resu
RUN chmod +x /sbin/tini /sbin/resu

ENTRYPOINT ["/sbin/tini", "--", "/sbin/resu", "nobody:nogroup", "--"]
```

Then, run your normal application either using the `CMD` Dockerfile directive or by putting a command on the `docker run` command line.

## Usage (Alpine Linux)

A special version is provided for Alpine users that is leverages musl-libc:

```Dockerfile
FROM debian:8.5

ENV TINI_VERSION v0.9.0
ENV RESU_VERSION 0.1.1

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /sbin/tini
ADD https://github.com/ben--/resu/releases/download/${RESU_VERSION}/resu-alpine /sbin/resu
RUN chmod +x /sbin/tini /sbin/resu

ENTRYPOINT ["/sbin/tini", "--", "/sbin/resu", "nobody:nogroup", "--"]
```

## Arguments

```shell
$ resu --help
usage: resu user:group -- cmd [args...]
```

Both user and group are mandatory.  They can either be names or numeric identifiers.  If they are names, then they must be available in `/etc/passwd` or `/etc/group` *within* the docker.

The second argument to `resu` is a double-dash after which the nested command and its arguments follow.
