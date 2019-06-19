# Kubernetes

* Master replication strategy
* Cross region (DR) strategy

## Core Objects

## Control Plane

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

* Pod
* Service
* Volume
* Namespace

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
# $ kubectl get service

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

# Get a list of all k8s resources you can get info on
$ kubectl api-resources

$ kubectl get [all | pods | deployments | events ...]

# Create a k8s deployment using an existing image
$ kubectl create deployment hello-node --image=gcr.io/hello-minikube-zero-install/hello-node

# By default, deployments are not exposed outside the k8s cluster.
# To expose a deployment:
#
# Note: LoadBalancer *should* work with minikube, but I was not able to get a valid
# EXTERNAL-IP. NodePort worked.
$ kubectl expose deployment hello-minikube --type=LoadBalancer --port=8080
$ kubectl expose deployment hello-minikube --type=NodePort --port=8080



```