# Docker

* Source : [Wikipedia](https://en.wikipedia.org/wiki/Docker_(software)

## Questions

* What operating system resources are exposed to the docker container?
  * CPU / memory / I/O
  * DNS
  * Network interfaces (-p)

* Docker command line completion?
* Where are images stored?
* How to ssh into a running container?
* Look into linux control groups.
* Docker uses `xhyve` on mac to virtualize the Docker Engine environment. What is `xhyve`?

--------------------------------------------------------------------------------

## Introduction

Docker containers wrap up software in a complete file system that contain everything the software needs to run : code, runtime, system tools, libraries. This guarantees the software will run the same, regardless of the host environment the container is running in.

### Why Docker?

* Lighter weight than a full VM.
* Guaranteed, predictable execution environment.


Docker uses resource isolation features of the Linux kernel:

* cgroups - provide resource limiting features (CPU, network, I/O).

* kernel namespaces - isolates the containers view of the operating system
  * network, user ids, mounted file systems

* union-capable file system (such as OverlayFS)

The overhead of a docker container is similar to a process. A single server or VM can run several containers simultaneously. A typical docker host can run 5-10 docker containers simultaneously.

Each container has it's own private view of the operating system - their own process ID, file system, network interfaces. Each container can be constrained to only use a defined amount of resources like CPU, I/O, and memory.

## Example Commands

// View all containers on machine (-a == all)
$ docker ps -a

// View all images
$ docker images

// Create a container from the "ubuntu:latest" image.
$ docker run -t -i ubuntu /bin/bash

-t : assigns a pseudo-tty inside the new container.
-i : interactive connection by grabbing the standard input
-d : run the container in the background
-P : map any required ports inside the container to your host
-p 80:5000 : maps the container port 5000 to host port 80

// Create a daemon container, running the given command in the container.
$ docker run -d ubuntu /bin/sh -c "while true; do echo hello world; sleep 1; done"

// Stop a docker container.
$ docker stop <container_id>

// List running processes within the container.
$ docker top <container_id>

// Full status information on a container
$ docker inspect <container_id>


## Creating a docker image.

* Build the application and create a `Dockerfile` for it.

* Build the docker image.

```
  -t : give your image a human friendly tag
  .  : tells `docker build` to look in the current directory for Dockerfile

  $ docker build -t pythonhello .
```

* Run the container

```
  -p link local port 4000 up to container port 80

  $ docker run -p 4000:80 pythonhello
```

* List containers

```
  $ docker container ls -a
```

* Create the repo on hub.docker.com

```
  // login to docker if you haven't already
  $ docker login

  // each image should have a tag
  // username/repository:tag
  $ docker tag <image_id> damonallison/docker-whale:latest

  // push your local image to docker hub
  $ docker push damonallison/docker-whale:latest

# Pull and run from your docker hub repository.
$ docker run damonallison/docker-whale