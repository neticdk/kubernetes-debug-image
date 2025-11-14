FROM ubuntu:24.04@sha256:e96e81f410a9f9cae717e6cdd88cc2a499700ff0bb5061876ad24377fcc517d7

ARG AZ_CLI_VERSION=2.72.0

RUN useradd -u 10001 scratchuser
RUN groupadd -g 30001 debuggroup 
RUN apt update -y; apt install -y vim netcat-openbsd curl wget bind9-host bind9-dnsutils python3 python3-pip npm libssl-dev postgresql-client mtr telnet traceroute tcpdump net-tools stress; apt clean
RUN pip3 install websocket-client azure-storage-blob azure-identity azure-cli==${AZ_CLI_VERSION}
RUN npm install -g wscat

USER 10001:30001
ENTRYPOINT ["sleep"]
CMD ["1800"]
