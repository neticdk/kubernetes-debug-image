FROM alpine:latest

ARG AZ_CLI_VERSION=2.40.0

RUN useradd -u 10001 scratchuser
RUN apk add --update --no-cache python3 vim netcat-openbsd curl wget bind-tools py3-pip
RUN pip3 install azure-storage-blob azure-identity azure-cli==${AZ_CLI_VERSION}

USER 10001
ENTRYPOINT ["tail", "-f", "/dev/null"]
