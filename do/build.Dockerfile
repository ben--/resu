FROM debian:11.0

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        make
RUN rm -rf /var/lib/apt/lists/* && \
    apt-get clean
