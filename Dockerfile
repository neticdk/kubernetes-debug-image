FROM cgr.dev/chainguard/wolfi-base@sha256:1c56f3ceb1c9929611a1cc7ab7a5fde1ec5df87add282029cd1596b8eae5af67

RUN apk add --no-cache \
  bash \
  busybox \
  curl \
  wget \
  vim \
  netcat-openbsd \
  bind-tools \
  python-3 \
  py3-pip \
  postgresql-client \
  mtr \
  tcpdump \
  net-tools \
  stress-ng \
  az \
  libssl3 \
  ca-certificates

USER root
RUN ln -s /usr/bin/busybox /usr/bin/telnet && \
  addgroup -g 30001 debuggroup && \
  adduser -u 10001 -G debuggroup -D scratchuser

USER 10001:30001
RUN pip install --no-cache-dir --user websocket-client azure-storage-blob azure-identity

ENV PATH="/home/scratchuser/.local/bin:$PATH"

ENTRYPOINT ["sleep"]
CMD ["3600"]
