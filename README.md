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
**Step 1** Go to `ravi-py-rest` folder in command terminal.
```
$ cd ravi-py-rest
```
**Step 2** Run `make.sh` to build the docker file locally.
```
$ ./make.sh
```
Output of this command may look like this for docker container build.
```
docker build -t ravi-py-rest /Users/..../docker_kubernetes/ravi-py-rest/
Sending build context to Docker daemon  8.704kB
Step 1/8 : FROM python:3.8
 ---> f5041c8ae6b1
Step 2/8 : MAINTAINER Ravi Singh
 ---> Using cache
 ---> a3469a619fb4
Step 3/8 : ENV TERM xterm-256color
 ---> Using cache
 ---> 631caeda446c
Step 4/8 : WORKDIR /code
 ---> Using cache
 ---> 624d8cf0274c
Step 5/8 : COPY requirements.txt .
 ---> c45a834a0cf7
Step 6/8 : RUN pip install -r requirements.txt
 ---> Running in 7097633bdae5
Collecting flask==1.1.2
  Downloading Flask-1.1.2-py2.py3-none-any.whl (94 kB)
Collecting psutil==5.8.0
  Downloading psutil-5.8.0-cp38-cp38-manylinux2010_x86_64.whl (296 kB)
Collecting click>=5.1
  Downloading click-7.1.2-py2.py3-none-any.whl (82 kB)
Collecting itsdangerous>=0.24
  Downloading itsdangerous-1.1.0-py2.py3-none-any.whl (16 kB)
Collecting Jinja2>=2.10.1
  Downloading Jinja2-2.11.2-py2.py3-none-any.whl (125 kB)
Collecting MarkupSafe>=0.23
  Downloading MarkupSafe-1.1.1-cp38-cp38-manylinux1_x86_64.whl (32 kB)
Collecting Werkzeug>=0.15
  Downloading Werkzeug-1.0.1-py2.py3-none-any.whl (298 kB)
Installing collected packages: MarkupSafe, Werkzeug, Jinja2, itsdangerous, click, psutil, flask
Successfully installed Jinja2-2.11.2 MarkupSafe-1.1.1 Werkzeug-1.0.1 click-7.1.2 flask-1.1.2 itsdangerous-1.1.0 psutil-5.8.0
Removing intermediate container 7097633bdae5
 ---> 8d9faf10e20a
Step 7/8 : COPY api.py .
 ---> f73a883b9f87
Step 8/8 : CMD [ "python", "./api.py" ]
 ---> Running in d97902f1406a
Removing intermediate container d97902f1406a
 ---> 0c0d1bf364d4
Successfully built 0c0d1bf364d4
Successfully tagged ravi-py-rest:latest
```
**Step 3** Run `./run.sh` to check if docker container works.
```
$ ./run.sh
```
Output will look like below - 
```
docker run -p 5050:5050 -it ravi-py-rest
 * Serving Flask app "api" (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://0.0.0.0:5050/ (Press CTRL+C to quit)
```
**Step 4** Check if the api is returning any result.
```
$ curl -X GET http://127.0.0.1:5050/api/v1/system/info

{"architecture":"x86_64","hostname":"007c0dc04583","ip-address":"172.17.0.2","mac-address":"02:42:ac:11:00:02","platform":"Linux","platform-release":"4.19.121-linuxkit","platform-version":"#1 SMP Tue Dec 1 17:50:32 UTC 2020","processor":"","ram":"10 GB"}
```

You can also open url `http://localhost:5050/` in browser which will open a static page indicating that our docker container and python flask server is working fine.

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