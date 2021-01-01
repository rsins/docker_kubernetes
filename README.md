# docker_kubernetes

## Overview
Try multi node kubernetes (k8s) cluster in local using docker.

**Table Of Contents**
* [Start Kind Clusters and setup nodes](#markdown-kind-cluster)
* [Build python app to be deployed in pods/containers](#markdown-create-docker)
* [Deploy your docker app instand to kind pods](#markdown-deploy-docker-app-to-kind)
* [Stop all services to cleanup](#markdown-cleanup)

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

Run below command in new terminal window to start k8s proxy (keep it running) -
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
Git Repo: [ravi-py-rest](../../../ravi-py-rest)

<a name="markdown-deploy-docker-app-to-kind"></a>
## Deploy your docker app instand to kind pods

Please note your kind containers are already running and also you have built the api server container locally.

**Step 1** Deploy application to pods by running below command (from folder `docker_kubernetes`).
```
$ cd docker_kubernetes
$ kubectl apply -f deploy-app.yaml

deployment.apps/ravi-py-rest created
```
To delete deployment you can use below command.
```
$ kubectl delete deployment ravi-py-rest
```
Get more information about pods.
```
$ kubectl get pods --output=wide

NAME                            READY   STATUS    RESTARTS   AGE   IP           NODE              NOMINATED NODE   READINESS GATES
ravi-py-rest-6bfbc48b86-8g45w   1/1     Running   0          40m   10.244.1.3   example-worker    <none>           <none>
ravi-py-rest-6bfbc48b86-pm8rz   1/1     Running   0          40m   10.244.1.2   example-worker    <none>           <none>
ravi-py-rest-6bfbc48b86-z2xzn   1/1     Running   0          40m   10.244.2.2   example-worker3   <none>           <none>
```

**Step 2** Get information about deployments & ReplicaSet objects.
* Deployments
```
$ kubectl get deployments ravi-py-rest
$ kubectl describe deployments ravi-py-rest
```
* ReplicaSet objects
```
$ kubectl get replicasets
$ kubectl describe replicasets
```
**Step 3** Create Service object to expose deployment.
```
$ kubectl expose -f expose-service.yaml

service/example-service exposed
```
Following command will display information about the service.
```
$ kubectl describe services example-service

Name:              example-service
Namespace:         default
Labels:            <none>
Annotations:       <none>
Selector:          run=load-balancer-example
Type:              ClusterIP
IP:                10.96.251.158
Port:              <unset>  5050/TCP
TargetPort:        5050/TCP
Endpoints:         10.244.1.2:5050,10.244.1.3:5050,10.244.2.2:5050
Session Affinity:  None
Events:            <none>


$ kubectl get service example-service

NAME              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
example-service   ClusterIP   10.96.251.158   <none>        5050/TCP   2m29s
```
To remove exposed service use below command.
```
$ kubectl delete service example-service
```

**Step 4** Forward the cluster port to localhost, it will make the cluster accessible from outside.
```
$ kubectl port-forward service/example-service 5050:5050

Forwarding from 127.0.0.1:5050 -> 5050
Forwarding from [::1]:5050 -> 5050
```
**Step 5** Check if the api is returning any result.
```
$ curl -X GET http://127.0.0.1:5050/api/v1/system/info

{"architecture":"x86_64","hostname":"ravi-py-rest-6bfbc48b86-9796h","ip-address":"10.244.1.4","mac-address":"3e:b1:51:05:fa:c2","platform":"Linux","platform-release":"4.19.121-linuxkit","platform-version":"#1 SMP Tue Dec 1 17:50:32 UTC 2020","processor":"","ram":"10 GB"}
```
You can also open url http://localhost:5050/ in browser which will open a static page indicating that our setup is working fine.

<a name="markdown-cleanup"></a>
## Stop all services to cleanup
Run below commands in order -
```
Terminate terminal command "kubectl port-forward service/example-service 5050:5050"
```
```
$ kubectl delete service example-service
```
```
$ kubectl delete deployment ravi-py-rest
```
```
Terminate terminal command "kubectl proxy --port=8080"
```
```
$ kind delete cluster --name example
```
To verify that everything has been terminated run below command, it should return no rows -
```
$ docker ps

CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```