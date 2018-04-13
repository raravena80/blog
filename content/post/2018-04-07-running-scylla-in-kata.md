---
title: "Running Scylla in Kata Containers"
date: 2018-04-07T14:17:00Z
lastmod: 2018-04-07T14:17:00Z
comments: true
categories:
 - oci
 - cncf
 - runtimes
 - containers
 - kata
tags: [ "containers", "runtimes", "cncf", "kata" ]
keywords: runtimes containers cncf Ricardo Aravena kata
description: Running Scylla in Kata Containers with some benchmarks
slug: scylla-in-kata-containers

---

The Kata community has been busy getting the first release out the door.

Virtual Machines have been around in the industry for over 20 years. One of the most attractive features of Kata is that it runs containers in VMs and VMs are very stable and provide very good isolation of your compute resources hardware. Furthermore, virtualization systems like KVM, Xen and VMware provide multiple ways to attach to dedicated storage. VMware takes this step even further by providing things like Storage VMotion.

With that, I set about running a two node ScyllaDB cluster in Kata containers and running some simple benchmarks. Scylla is a high-performance Cassandra clone written from scratch in C++. The folks that started ScyllaDB are the same folks that started the KVM project that eventually made it into the Linux Kernel.

I used a single C2S bare metal machine from [ScaleWay](https://www.scaleway.com)

The specs are these:

* 4 Dedicated x86 64bit Cores
* 8GB Memory
* 50GB SSD Disk


I started with the Kata developer instructions [here](https://github.com/kata-containers/documentation/blob/master/Developer-Guide.md)

One minor change that I had to make was the configuration for qemu under `/usr/share/defaults/kata-containers/configuration.toml`. Instead of qemu, Kata runs under [qemu-lite](https://github.com/intel/qemu-lite) which is part of the [Clear Containers](https://clearlinux.org/documentation/clear-containers/architecture-overview) project at Intel

```
# /usr/share/defaults/kata-containers/configuration.toml
[hypervisor.qemu]
# Change this
# path = "/usr/bin/qemu-system-x86_64"
# to this
path = "/usr/bin/qemu-lite-system-x86_64"
```
Then I ran some performance benchmarks that were previously run with Scylla by the IBM folks. Note that the IBM benchmarks are comparing x86 with Power8 processors and these benchmarks are simply to establish a baseline and demonstrate that we can run Scylla in Kata containers. The idea is to get some baseline and see how Scylla performs in Kata.

You can read more about the IBM tests [here](https://www.ibm.com/developerworks/library/l-performance-scylla/)

In this case, each node is running in its Kata container (running in separate qemu-lite VMs). I followed some of the instructions in the [docker hub Scylla page to setup my cluster](https://hub.docker.com/r/scylladb/scylla/). I just provided the `--runtime kata-runtime` parameter for each container and the `-p 9042:9042` parameter so that I could connect to Scylla from my bare-metal machine.

My commands:

```
# docker run --runtime kata-runtime --name my-scylla -p 9042:9042 -d scylladb/scylla
# docker run --runtime kata-runtime --name my-scylla2 -d scylladb/scylla --seeds="$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' my-scylla)"
```
Checked the Scylla cluster:

```
# docker exec -it my-scylla nodetool status
Datacenter: datacenter1
=======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address     Load       Tokens       Owns (effective)  Host ID                               Rack
UN  172.17.0.3  110.42 KB  256          100.0%            22fec874-49e2-4a1f-b1b0-890a54f39142  rack1
UN  172.17.0.2  117.56 KB  256          100.0%            7ee27713-194b-4cef-a8ca-ac47c7c90063  rack1

#
```

Then I ran the `cassandra-stress` test provided in the [cassandra distribution](http://cassandra.apache.org/download/):

Write test:

```
# cassandra-stress write no-warmup n=2500000 -node 127.0.0.1 -rate threads=200 -mode native cql3 -schema keyspace=ksX
...
Results:
Op rate                   :    3,594 op/s  [WRITE: 3,594 op/s]
Partition rate            :    3,594 pk/s  [WRITE: 3,594 pk/s]
Row rate                  :    3,594 row/s [WRITE: 3,594 row/s]
Latency mean              :   55.6 ms [WRITE: 55.6 ms]
Latency median            :   48.7 ms [WRITE: 48.7 ms]
Latency 95th percentile   :  124.3 ms [WRITE: 124.3 ms]
Latency 99th percentile   :  146.8 ms [WRITE: 146.8 ms]
Latency 99.9th percentile :  189.9 ms [WRITE: 189.9 ms]
Latency max               :  435.4 ms [WRITE: 435.4 ms]
Total partitions          :  2,500,000 [WRITE: 2,500,000]
Total errors              :          0 [WRITE: 0]
Total GC count            : 0
Total GC memory           : 0.000 KiB
Total GC time             :    0.0 seconds
Avg GC time               :    NaN ms
StdDev GC time            :    0.0 ms
Total operation time      : 00:11:35
```

Read test:

```
# cassandra-stress read no-warmup n=2500000 -node 127.0.0.1 -rate threads=200 -mode native cql3 -schema keyspace=ksX
...
Results:
Op rate                   :    1,453 op/s  [READ: 1,453 op/s]
Partition rate            :    1,453 pk/s  [READ: 1,453 pk/s]
Row rate                  :    1,453 row/s [READ: 1,453 row/s]
Latency mean              :  137.5 ms [READ: 137.5 ms]
Latency median            :  135.4 ms [READ: 135.4 ms]
Latency 95th percentile   :  280.5 ms [READ: 280.5 ms]
Latency 99th percentile   :  315.6 ms [READ: 315.6 ms]
Latency 99.9th percentile :  364.6 ms [READ: 364.6 ms]
Latency max               :  563.1 ms [READ: 563.1 ms]
Total partitions          :  2,500,000 [READ: 2,500,000]
Total errors              :          0 [READ: 0]
Total GC count            : 0
Total GC memory           : 0.000 KiB
Total GC time             :    0.0 seconds
Avg GC time               :    NaN ms
StdDev GC time            :    0.0 ms
Total operation time      : 00:28:40
```


Then I ran the same tests on the same machine without Kata containers.

Write test:

```
...
Results:
Op rate                   :    8,793 op/s  [WRITE: 8,824 op/s]
Partition rate            :    8,793 pk/s  [WRITE: 8,824 pk/s]
Row rate                  :    8,793 row/s [WRITE: 8,824 row/s]
Latency mean              :   22.6 ms [WRITE: 22.6 ms]
Latency median            :   20.4 ms [WRITE: 20.4 ms]
Latency 95th percentile   :   44.3 ms [WRITE: 44.3 ms]
Latency 99th percentile   :   64.4 ms [WRITE: 64.4 ms]
Latency 99.9th percentile :  125.8 ms [WRITE: 125.8 ms]
Latency max               :  463.5 ms [WRITE: 463.5 ms]
Total partitions          :  2,500,000 [WRITE: 2,500,000]
Total errors              :          0 [WRITE: 0]
Total GC count            : 0
Total GC memory           : 0.000 KiB
Total GC time             :    0.0 seconds
Avg GC time               :    NaN ms
StdDev GC time            :    0.0 ms
Total operation time      : 00:04:44
```

Read test:

```
...
Results:
Op rate                   :    7,039 op/s  [READ: 7,059 op/s]
Partition rate            :    7,039 pk/s  [READ: 7,059 pk/s]
Row rate                  :    7,039 row/s [READ: 7,059 row/s]
Latency mean              :   28.3 ms [READ: 28.3 ms]
Latency median            :   22.3 ms [READ: 22.3 ms]
Latency 95th percentile   :   73.4 ms [READ: 73.4 ms]
Latency 99th percentile   :  107.7 ms [READ: 107.7 ms]
Latency 99.9th percentile :  157.9 ms [READ: 157.9 ms]
Latency max               :  582.5 ms [READ: 582.5 ms]
Total partitions          :  2,500,000 [READ: 2,500,000]
Total errors              :          0 [READ: 0]
Total GC count            : 0
Total GC memory           : 0.000 KiB
Total GC time             :    0.0 seconds
Avg GC time               :    NaN ms
StdDev GC time            :    0.0 ms
Total operation time      : 00:05:55
```

![oprate](https://user-images.githubusercontent.com/7659560/38760120-62c86ac2-3f2e-11e8-9013-30e17695ce66.png)
![meanlatency](https://user-images.githubusercontent.com/7659560/38760803-fa10540e-3f32-11e8-99a2-f0be37bd0eab.png)
![99thlatency](https://user-images.githubusercontent.com/7659560/38760128-6c4bd37c-3f2e-11e8-996b-810ed3220a80.png)


If we look at Ops per second, results show that our 2 node Scylla cluster on the same machine running in 2 Kata containers is about 40% slower for writes and 80% slower for reads than running Scylla on 2 containers on bare metal. Other metrics such as latency show similar patterns in where it's higher for Kata containers. This makes sense since Virtualization adds an extra layer.

Read performance overall is slower in both cases since Scylla was not started with any tuning and both nodes are running on the same machine. What is more interesting is that the read performance is slower for Kata by a higher percentage than writes. I can't make a definitive conclusion on why this is the case, but I guess is that the I/O between the client and the VM is going through the kata-shim which is adding extra overhead.

I expect these numbers to get better as the Kata team continues to tune the qemu parameters and establishes best practices for Kata containers as well as some of the vendors making it easier to improve performance and security such as Intel and AMD. For example, in real-world applications, you would make sure that your VM is talking directly to the hardware and in most cases, you would want to run your Scylla nodes on separate metal.

Due to privacy concerns, compliance requirements such as [GDPR](https://en.wikipedia.org/wiki/General_Data_Protection_Regulation), and bugs such as [Spectre](https://en.wikipedia.org/wiki/Spectre_(security_vulnerability)) and [Meltdown](https://en.wikipedia.org/wiki/Meltdown_(security_vulnerability)), more organizations will continue to adopt running containers in a secure way.  Although we are very early in the Kata project, I'm pretty excited about its ability to run reliable and secure workloads. The performance will only get better with support for more applications with different types of memory, storage and networking requirements. Also, as the team continues to add resources we'll be doing more benchmarks with hardware and more machines in different cluster configurations, so stay tuned.

It's worth mentioning that there's also another interesting [blog](https://www.scylladb.com/2018/03/29/scylla-kubernetes-overview/) explaining how to run Scylla in Kubernetes. So you can also run Scylla in Kata Containers on top of Kubernetes using Stateful sets.

Go Kata!

For more information about the Kata Containers project you can visit https://katacontainers.io.

[Part 2]({{< relref "2018-04-12-running-scylla-in-kata-part-2.md" >}})
