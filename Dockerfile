FROM ubuntu:22.04 AS builder
RUN apt-get update && apt-get install -y \
    git build-essential cmake libuv1-dev libssl-dev libhwloc-dev wget
RUN git clone https://github.com/scala-network/XLArig.git /xlarig
WORKDIR /xlarig
RUN mkdir build && cd build && cmake .. && make -j$(nproc)

FROM ubuntu:22.04
RUN apt-get update && apt-get install -y \
    libuv1 libssl3 libhwloc15 ca-certificates && \
    rm -rf /var/lib/apt/lists/*
COPY --from=builder /xlarig/build/xlarig /usr/local/bin/xlarig
ENTRYPOINT ["xlarig"]
CMD ["--help"]
