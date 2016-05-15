FROM debian:8.1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python \
        python-pip \
        wget \
    && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN wget -qO- https://get.docker.com/ | sh

RUN pip install \
    behave
