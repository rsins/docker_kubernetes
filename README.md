# docker_kubernetes
Try multi node kubernetes (k8s) cluster in local using docker.


## Start Kind Clusters and setup nodes
System : Macbook

**Step 1** Install kind binary.
```
brew install kind
```

**Step 2** Create kind cluster (name = exmaple-kind) using yaml config file.
```
kind create cluster --name example --config kind-config.yaml
```
This will start cluster with one control plane and 3 worker pods.

**Step 3** Check if k8s apis are running and can be assessed.

Run below to start k8s proxy-
```
kubectl proxy --port=8080
```

Then run below to check if k8s apis are assessible -
```
curl http://localhost:8080/api/
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
