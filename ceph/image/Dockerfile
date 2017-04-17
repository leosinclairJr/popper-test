FROM ceph/daemon:1dc4892

ENV DEBIAN_FRONTEND=noninteractive
RUN echo "==> Install deps" && \
    apt-get update -y && \
    apt-get install -y linux-image-3.13.0-85-generic && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* debian/
