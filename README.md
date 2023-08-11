# kubernetes-debug-image
Debug image for debugging within a kubernetes cluster.


# Dockerfile
Example of dockerfile with tools for debugging.\
Tools can be added or removed in ```apt install```. 

```
FROM ubuntu:22.04

ARG AZ_CLI_VERSION=2.40.0

RUN useradd -u 10001 scratchuser
RUN groupadd -g 30001 scratchuser
RUN apt update; apt -y install vim netcat-openbsd curl wget bind9-host bind9-dnsutils python3 python3-pip postgresql-client; apt clean
RUN pip3 install azure-storage-blob azure-identity azure-cli==${AZ_CLI_VERSION}

USER 10001:30001
ENTRYPOINT ["tail", "-f", "/dev/null"]
```

# Debug deployment
Example of yaml file containing the deployment of debugger pods.\
Namespace needs to be changed to match the environment it's deployed in.\
Currently the image is set to the default debug-image.\
Consider adding egress rules for debugging the network.

```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: debug-deployment
  namespace: your-namespace
spec:
  replicas: 1
  selector:
    matchLabels:
      appName: debug
  template:
    metadata:
      labels:
        appName: debug
        netic.dk/network-rules-egress: app-name
        netic.dk/network-component: other-app-name
    spec:
      securityContext:
        runAsUser: 10001
        runAsGroup: 30001
      containers:
      - name: debug-pod
        image: ghcr.io/neticdk/kubernetes-debug-image:<tag>
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop:
              - "ALL"
```
