# docker_kubernetes

## Overview
Try multi node kubernetes (k8s) cluster in local using docker.

**Table Of Contents**
* [Start Kind Clusters and setup nodes](#markdown-kind-cluster)
* [Build python app to be deployed in pods/containers](#markdown-create-docker)
* [Deploy your docker app instand to kind pods](#markdown-deploy-docker-app-to-kind)

<a name="markdown-kind-cluster"></a>
## Start Kind Clusters and setup nodes
`System : Macbook`

**Step 1** Install kind binary.
```

$ brew install kind
```

**Step 2** Create kind cluster (name = exmaple-kind) using yaml config file (from folder `docker_kubernetes`).
```
$ cd docker_kubernetes
$ kind create cluster --name example --config kind-config.yaml
```
This will start cluster with one control plane and 3 worker pods.

To delete the cluster you can run below command.
```
kind delete cluster --name example
```

**Step 3** Check if k8s apis are running and can be assessed.

Run below to start k8s proxy-
```
$ kubectl proxy --port=8080
```

Then run below to check if k8s apis are assessible -
```
$ curl http://localhost:8080/api/
```
Output will be similar to below - 
```
{
  "kind": "APIVersions",
  "versions": [
    "v1"
  ],
  "serverAddressByClientCIDRs": [
    {
      "clientCIDR": "0.0.0.0/0",
      "serverAddress": "172.18.0.5:6443"
    }
  ]
}
```

<a name="markdown-create-docker"></a>
## Build python app to be deployed in pods/containers
Check the repo `ravi-py-rest` for more detail.
Git Repo: [ravi-py-rest](../ravi-py-rest)

<a name="markdown-deploy-docker-app-to-kind"></a>
## Deploy your docker app instand to kind pods

Please note your kind containers are already running and also you have built the api server container locally.

**Step 1** Deploy application to pods by running below command (from folder `docker_kubernetes`).
```
$ cd docker_kubernetes
$ kubectl apply -f deploy-app.yaml

deployment.apps/ravi-py-api created
```

**Step 2** Display information about deployments.
```
$ kubectl get deployments ravi-py-api
$ kubectl describe deployments ravi-py-api
```