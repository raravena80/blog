---
title: "The Boom of Container Runtimes"
date: 2018-03-04T14:17:00Z
lastmod: 2018-03-04T14:17:00Z
comments: true
categories:
 - oci
 - cncf
 - runtimes
 - containers
tags: [ "containers", "runtimes", "cncf" ]
keywords: runtimes containers cncf Ricardo Aravena
description: The boom of container runtimes
slug: container-runtimes-cncf

---

It has been about 4 years since Docker exploded into the scene of Cloud Infrastructure.
With that came a shift in cloud applications from monolithic to microservices. Containers
made it easy for developers to deploy directly to production mostly caring about the scope of
her/his microservice.

Enter container orchestration tools such as Kubernetes, Mesos, AWS ECS, GKE, Azure Container Service which
allow cloud operations to manage containers at scale. Setup these tools with a redundant masters as
quorum systems (k8s, mesos) and add hundreds of nodes or slaves and automatically scale your
containers up and down depending on demand.

This introduced another challenge where organizations have been trying to figure out what is the best way
to run their workloads in these container orchestration tools. Docker has been the default for
years but then came runtimes like rkt that tried to create a simpler approach. Then came OCI to try to
standardize the future of runtimes started initially from the same Docker/Rkt folks.

Furthermore, Kubernetes had to add support for rkt because of priorities and the request from the community.
Afterward, they figured that they didn't want to add specific support for a new container runtime so they created the CRI
(Container Runtime Interface) to talk to OCI compliant runtimes.

This has fueled the creation of more OCI compliant runtimes as seen in [KubeCon/CloudNativeCon North America 2017](http://events17.linuxfoundation.org/events/kubecon-and-cloudnativecon-north-america). In particular, [CRIO](http://cri-o.io/), [Kata containers](https://katacontainers.io/) and [crun](https://github.com/giuseppe/crun) each with their unique capabilities, advantages and disadvantages.

Hear more about the different containers in [my talk](https://kccnceu18.sched.com/event/Dqtw/whats-up-with-all-the-different-container-runtimes-ricardo-aravena-branch-metrics-intermediate-skill-level) at [KubeCon/CloudNaticeCon EU](https://events.linuxfoundation.org/events/kubecon-and-cloudnativecon-europe) next month.
