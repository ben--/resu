FROM debian:8.1

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        python \
        python-pip \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean

RUN pip install \
    behave
