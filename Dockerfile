FROM ubuntu:latest

ARG AZ_CLI_VERSION=2.40.0

RUN useradd -u 10001 scratchuser
RUN apt update -y; apt install -y vim netcat-openbsd curl wget bind9-host bind9-dnsutils python3 python3-pip postgresql-client; apt clean
RUN pip3 install azure-storage-blob azure-identity azure-cli==${AZ_CLI_VERSION}

USER 10001
ENTRYPOINT ["tail", "-f", "/dev/null"]
