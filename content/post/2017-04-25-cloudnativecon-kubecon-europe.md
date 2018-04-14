---
title: "CloudNativeCon KubeCon Europe"
date: 2017-04-25T16:28:29Z
lastmod: 2017-04-25T16:28:29Z
comments: true
categories: 
 - docker
tags: [ "cloudnative", "kubecon", "kubernetes", "cncf" ]
keywords: cloudnative kubecon kubernetes Ricardo Aravena
description: Summary of CloudNativeCon/KubeCon Europe in Berlin
slug: cloudnativecon-kubecon-europe

---

This same blog entry is [here](https://www.cncf.io/blog/2017/04/18/diversity-scholarship-series-berlin-eyes-cloud-infrastructure-fanatic/). Thanks to the cncf folks who helped me put this together.
* * *

I’ve attended many conferences before, but I was happy to get the diversity scholarship to attend CloudNativeCon + KubeCon Europe 2017 in Berlin as there is always so much more to learn. It was my first time attending an event organized by the Linux Foundation, and I hope to attend more in the future.
I loved all the insights and advances that I obtained through all of the highlighted Cloud Native projects including Kubernetes, gRPC, OpenTracing, Prometheus, Linkerd, Fluentd and OpenDNS from the variety of industry leaders.  The keynotes were quite memorable as well, including the Kubernetes 1.6 updates by Aparna Sinha (Google), Federation from Kelsey Hightower (Google), Kubernetes Security Updates from Clayton Coleman (Red Hat), Helm from Michelle Noorali (Deis), Scaling Kubernetes from Joe Beda (Heptio) and Quay from Brandon Phillips (CoreOS).

There were many sessions, and they overlapped so anybody can just come out with something new learned. Some highlights from some of the sessions I attended (not in order):

* * *

#### How We Run Kubernetes in Kubernetes, aka Kubeception – Timo Derstappen, Giant Swarm

Learned how Giant Swarm uses Kubernetes to deploy encrypted and isolated clusters of Kubernetes. They treat these clusters as TPSs (Third Party Resources)
Explained how they use a “mother” Kubernetes to deploy and manage fully-isolated and encrypted Kubernetes clusters for different customers or teams.
https://github.com/giantswarm

#### Life of a Packet in Kubernetes – Michael Rubin Senior Staff Engineer & TLM, Google

I learned about where an IP packet goes to in Kubernetes within one pod, multiple pods, and different servers. Also how it fits together with flannel. https://github.com/coreos/flannel

#### Programming Kubernetes with the Kubernetes Go SDK – Aaron Schlesinger Sr. Software Engineer, Deis

I learned how to use the Kubernetes go client library to build TPS Third party services. Including a coding example and demo
https://github.com/arschles/2017-KubeCon-EU

#### Go + Microservices = Go Kit – Peter Bourgon, Go Kit/Weaveworks

This specific session was a great talk that showed how to build go microservices using Go Kit. What was also interesting was that the kit allows you to implement your microservice using standard rest or if in the future you want to start using gRPC you can also do so. Also, this is the perfect type of microservice that you can deploy to a Kubernetes cluster.


#### Loki: An OpenSource Zipkin / Prometheus Mashup, Written in Go Tom Wilkie – Director of Software Engineering, Weaveworks
https://github.com/weaveworks-experiments/loki

I learned about Loki is a Zipkin-compatible distributed tracer written in Go. It uses Prometheus’ service discovery to find about the services and examine them.
* * *
![CoffeeTalk](https://user-images.githubusercontent.com/7659560/38763265-98f0ad94-3f4c-11e8-93ad-3f2d25b3af00.png)

As a Latino leader (originally from Chile), I enjoyed the diversity talk very much as well. It was an interesting conversation led by Sarah Conway from the Linux Foundation with a variety of different attendees including Kris Nova, a previous diversity scholarship recipient. The general consensus is that the industry still needs to continue to do more.  I hope they keep on having these talks in future conferences since this is topic that is not very openly talked about, for fear or whatever reasons, but I believe part of the culture of open source is being ‘Open’ and talk about all the different issues and challenges in industry when it comes to being more inclusive.

Specifically for example, when it comes to companies hiring, there are just a few that are doing things to make it truly more inclusive, there are those that say that they are doing things (but not practicing) and there is the large majority that is not doing anything at all.

![CoffeeImage](https://user-images.githubusercontent.com/7659560/38763266-9bc57aea-3f4c-11e8-9c3b-64e6d2d83b40.png)

The environment and event were great overall. From participating in the morning run around Berlin with some fellow conference attendees to the closing party with the great food and drinks :-). What a great way to start and end your day.

![MorningRun](https://user-images.githubusercontent.com/7659560/38763267-9ee3ef5e-3f4c-11e8-877d-a1c6301332a5.png)

![Party](https://user-images.githubusercontent.com/7659560/38763262-915b6fe2-3f4c-11e8-9cd2-56736d2b6207.jpg)

Thanks for the fantastic experience and looking forward to next the CloudNativeCon + KubeCon North America 2017 in Austin. Consider applying for a scholarship to the North America event. Applications can be found here and are due October 13th.

