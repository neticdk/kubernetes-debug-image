FROM cgr.dev/chainguard/wolfi-base@sha256:b5f4a33fa2fee95dd79535e069bafd60f52085c5786677da5724414374c5194c

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
