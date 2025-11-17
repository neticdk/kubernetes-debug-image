FROM ubuntu:24.04@sha256:c35e29c9450151419d9448b0fd75374fec4fff364a27f176fb458d472dfc9e54

ARG AZ_CLI_VERSION=2.72.0

RUN useradd -u 10001 scratchuser
RUN groupadd -g 30001 debuggroup 
RUN apt update -y; apt install -y vim netcat-openbsd curl wget bind9-host bind9-dnsutils python3 python3-pip npm libssl-dev postgresql-client mtr telnet traceroute tcpdump net-tools stress; apt clean
RUN pip3 install websocket-client azure-storage-blob azure-identity azure-cli==${AZ_CLI_VERSION}
RUN npm install -g wscat

USER 10001:30001
ENTRYPOINT ["sleep"]
CMD ["1800"]
