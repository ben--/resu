FROM debian:8.5

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        gdb \
        libc-dbg \
        llvm-3.5 \
        make \
        strace
RUN rm -rf /var/lib/apt/lists/* && \
    apt-get clean

ADD cmocka-1.0.1.tar.xz /usr/src
RUN cd /usr/src/cmocka-1.0.1 \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=/usr .. \
    && make \
    && make install

ENV ASAN_SYMBOLIZER_PATH=/usr/bin/llvm-symbolizer-3.5
ENV ASAN_OPTIONS=symbolize=1
