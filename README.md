# kubernetes-debug-image
Debug image for debugging within a kubernetes cluster.

# Debug deployment
Example of yaml file containing the deployment of a debugger Job.\
Namespace needs to be changed to match the environment it's deployed in.\
Currently the image is set to the default debug-image.\
Consider adding egress rules for debugging the network. \
Default duration before container terminates is 30 minutes. \
This can be overwritten in the args field on the container. \
The time must be set in seconds.

The Job is configured with `ttlSecondsAfterFinished`, ensuring it cleans itself up automatically after completion.

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: debug-job
  namespace: <namespace>
  labels:
    appName: debug
spec:
  # Automatically cleans up the Job and Pod 300 seconds (5mins) after completion
  ttlSecondsAfterFinished: 300
  template:
    metadata:
      labels:
        appName: debug
        netic.dk/network-rules-egress: app-name
        netic.dk/network-component: other-app-name
    spec:
      restartPolicy: Never
      securityContext:
        runAsUser: 10001
        runAsGroup: 30001
      containers:
      - name: debug-container
        image: ghcr.io/neticdk/kubernetes-debug-image:latest
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

### K9s Plugin
Here is a K9s plugin that you can add to your `path/to/your/plugins.yaml`. This allows you to press `Shift-D` while inside a namespace view to spawn this specific debug job instantly with a unique name.

```yaml
plugins:
  debug-job:
    shortCut: Shift-D
    description: "Deploy Debug Job"
    scopes:
      - namespaces
    command: bash
    background: true
    confirm: true
    args:
      - -c
      - |
        kubectl apply -f - <<EOF
        apiVersion: batch/v1
        kind: Job
        metadata:
          name: debug-job-$(date +%s)
          namespace: $NAME
          labels:
            appName: debug
        spec:
          ttlSecondsAfterFinished: 300
          template:
            metadata:
              labels:
                appName: debug
                netic.dk/network-rules-egress: app-name
                netic.dk/network-component: other-app-name
            spec:
              restartPolicy: Never
              securityContext:
                runAsUser: 10001
                runAsGroup: 30001
              containers:
              - name: debug-container
                image: ghcr.io/neticdk/kubernetes-debug-image:latest
                args: ["1800"]
                securityContext:
                  capabilities:
                    drop:
                    - "ALL"
                  allowPrivilegeEscalation: false
        EOF
```
