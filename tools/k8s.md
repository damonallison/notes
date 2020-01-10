# Kubernetes

* Roles / access
* Master replication strategy
* Namespacing / environment strategy
* Cross region (DR) strategy
* Ingress / traffic routing strategy
* Autoscaling strategy (min 1, max ?)
* Rolling update / rollback strategy (password rotations?)

## Kubernetes Introduction

Kubernetes manages container deployments.

* Auto-scaling / failover / load balancing
* Storage mounting
* Efficiently distributes containers to nodes to make the best use of node
  resources
*

## Components

### Master Components

Responsible for keeping the cluster's current state in sync with the desired
state. The control plane includes:

* Processes running on master:
  * kube-apiserver
  * kube-controller-manager
  * kube-scheduler

* Processes running on non-master nodes:
  * kubelet - communicates with master
  * kube-proxy - network proxy reflecting k8s networking on the node

## Basic Kube Objects

### Pod

A pod represents a group of 1 or more containers and shared resources.

Shared resources include:

* Storage

* Networking. The containers in a Pod share a unique cluster IP address and port
  space. Each pod has a unique IP address, which is not exposed by default. In
  order for pods to be exposed, you create a service.

* Configuration about how to run each container - including image version or
  specific ports to use.


### Service

A service is an abstraction which defines a logical set of Pods and a policy to
access them.

### Volume

### Namespace

## High(er) level abstractions

* ReplicaSet
* Deployment
* StatefulSet
* DaemonSet
* Job

## minikube

```bash

# Create a new (local) cluster as a VM in your hypervisor
$ minikube start

# Get a list of services
$ kubectl get service

# Opens the service URL in Chrome
$ minikube service hello-minikube

# Start the k8s dashboard
$ minikube dashboard
```

## kubectl Commands

```sh

# Switch context back to minikube
$ kubectl config use-context minikube
$ kubectl config view

#
# Inspecting k8s objects
#
# Get a list of all k8s resources you can get info on
#
$ kubectl api-resources

$ kubectl get [all | pods | services | deployments | events | nodes | namespaces ...]

# Detailed information about an object
$ kubectl describe [name]

# Read console logs (STDOUT)
$ kubectl logs $POD_NAME | Container name


# Create a k8s deployment using an existing image
$ kubectl create deployment hello-node --image=gcr.io/hello-minikube-zero-install/hello-node

#
# Services
#
# By default, deployments are *not* exposed outside the k8s cluster.
# To expose a deployment:
#
#
# NodePort
#
# NodePort opens a specific port on all the nodes, and any traffic sent
# to the port is forwarded to the service.
#
# NodePort should be used for development or local scenarios only.
$ kubectl expose deployment hello-minikube --type=NodePort --port=8080

#
# LoadBalancer
#
# All traffic sent to a LoadBalancer will be forwarded to the service.
#
# Each serice you expose with a LoadBalancer will get it's own IP address
# and you *may* have to pay for a LoadBalancer per service.
$ kubectl expose deployment hello-minikube --type=LoadBalancer --port=8080

#
# NOTE: If you are running in minikube, you'll need to access the service
#       the VM or minikube IP. This will open a Chrome window with the URL
#       for the given service.
$ minikube service [service-name]



# Proxy
# Exposes the k8s API and objects thru a proxy endpoint.
#
# You should only use this for debugging purposes - to connect directly
# to a service or pod.
#
# Do *not* use this to expose services to the internet or in production!
#
$ kubectl proxy --port=8080


#
# exec
#
# Execute commands directly on a Pod's container.
#
# To start an interactive terminal on the first container in the pod
$ kubectl exec -ti $POD_NAME bash

# If the pod has multiple containers, use -c container-name
$ kubectl exec -ti $POD_NAME -c $CONTAINER_NAME bash

#
# scale
#
$ kubectl scale deployments/hello-node --replicas=4

$ kubectl get pods -o wide


#
# Updates
#
# Update the image to a new version.
#
# This will perform a rolling update. Load balancing is maintained during the release.
# Only running pods will accept traffic.
$ kubectl set image deployments/hello-node hello-node=image:v2

# Rollout status can be monitored with
$ kubectl rollout status deployments/hello-node
$ kubectl rollout history deployments/hello-node

# Undoing a rollout
$ kubectl rollout undo deployments/hello-node


```