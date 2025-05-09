# kubernetes-debug-image
Debug image for debugging within a kubernetes cluster.

# Debug deployment
Example of yaml file containing the deployment of debugger pods.\
Namespace needs to be changed to match the environment it's deployed in.\
Currently the image is set to the default debug-image.\
Consider adding egress rules for debugging the network. \
Default duration before container terminates is 30 minutes. \
This can be overwritten in the args field on the container. \
The time must be set in seconds. 
```
apiVersion: v1
kind: Pod
metadata:
  name: debug-pod
  namespace: <namespace>
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
    args: ["1800"]
    securityContext:
      capabilities:
        drop:
        - "ALL"
      allowPrivilegeEscalation: false
```

# Installation
Change ```tag``` to a version or set to ```latest```.\
Run below command to pull the image to docker, or set it for the deployment manifest.\
``` docker pull ghcr.io/neticdk/kubernetes-debug-image:tag ```
