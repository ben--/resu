FROM debian:11.0

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean

RUN pip install \
    behave \
    sure
