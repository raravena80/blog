---
title: "Running Scylla in Kata Containers Part 2"
date: 2018-04-13T14:17:00Z
lastmod: 2018-04-13T14:17:00Z
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
slug: scylla-in-kata-containers-part-2

---



Following up on [Part 1]({{< relref "2018-04-07-running-scylla-in-kata.md" >}}) for  my previous blog and recommendations from 
[Archana Shinde](https://github.com/amshinde) and [Graham Whaley](https://github.com/grahamwhaley).
I made a few tweaks to the `/usr/share/defaults/kata-containers/configuration.toml` configs.

The machine specs are the same:

* C2S bare metal machine from [ScaleWay](https://www.scaleway.com)
* 4 Dedicated x86 64bit Cores
* 8GB Memory
* 50GB SSD Disk

These are the changes in the configs (from the default)

```
default_vcpus = 4
default_memory = 3072
enable_iothreads = true
```

I also changed the number of operations from `2500000` to `500000` and first I ran the tests using
the devicemapper configs in Docker with an external `/var/lib/scylla` volume. Also, where the
file system traffic goes through 9pfs.

Results:

```
kata_write_9pfs
---------------------------------------
op rate                    : 3,335 op/s [WRITE: 3,358 op/s]
partition rate             : 3,335 pk/s [WRITE: 3,358 pk/s]
row rate                   : 3,335 row/s [WRITE: 3,358 row/s]
latency mean               : 59.4 ms [WRITE: 59.4 ms]
latency median             : 43.8 ms [WRITE: 43.8 ms]
latency 95th percentile    : 163.3 ms [WRITE: 163.3 ms]
latency 99th percentile    : 261.4 ms [WRITE: 261.4 ms]
latency 99.9th percentile  : 439.1 ms [WRITE: 439.1 ms]
latency max                : 901.3 ms [WRITE: 901.3 ms]
total gc count             : 0
total gc memory            : 0.000 KiB
total gc time              : 0.0 seconds
avg gc time                : NaN ms
stddev gc time             : 0.0 ms
Total operation time       : 00:02:29
cmd: write no-warmup n=500000 -node 127.0.0.1 -rate threads=200 -mode native cql3 -schema keyspace=ksX -graph file=graphfile revision=kata_write_9pfs title=Kata_Write_9pfs
```
![screen shot 2018-04-12 at 11 20 51 am](https://user-images.githubusercontent.com/7659560/38696326-b4bcedbc-3e43-11e8-95d2-22177e2e1a60.png)

```
kata_read_9pfs
---------------------------------------
op rate                    : 2,704 op/s [READ: 2,704 op/s]
partition rate             : 2,704 pk/s [READ: 2,704 pk/s]
row rate                   : 2,704 row/s [READ: 2,704 row/s]
latency mean               : 73.5 ms [READ: 73.5 ms]
latency median             : 31.5 ms [READ: 31.5 ms]
latency 95th percentile    : 379.6 ms [READ: 379.6 ms]
latency 99th percentile    : 552.1 ms [READ: 552.1 ms]
latency 99.9th percentile  : 665.3 ms [READ: 665.3 ms]
latency max                : 828.9 ms [READ: 828.9 ms]
total gc count             : 0
total gc memory            : 0.000 KiB
total gc time              : 0.0 seconds
avg gc time                : NaN ms
stddev gc time             : 0.0 ms
Total operation time       : 00:03:04
cmd: read no-warmup n=500000 -node 127.0.0.1 -rate threads=200 -mode native cql3 -schema keyspace=ksX -graph file=graphfile revision=kata_read_9pfs title=Kata_9pfs
```
![screen shot 2018-04-12 at 11 20 37 am](https://user-images.githubusercontent.com/7659560/38696345-bc22321a-3e43-11e8-92e1-ef3fb640a353.png)

Complete results can be downloaded [here](https://github.com/kata-containers/runtime/files/1904448/graphfile_9pfs.gz). (gunzip and open on your browser)

Now with an internal /var/lib/scylla which is running in the VM and the traffic doesn't go through
9pfs.

Results:

```
kata_write_local
---------------------------------------
op rate                    : 3,336 op/s [WRITE: 3,336 op/s]
partition rate             : 3,336 pk/s [WRITE: 3,336 pk/s]
row rate                   : 3,336 row/s [WRITE: 3,336 row/s]
latency mean               : 59.5 ms [WRITE: 59.5 ms]
latency median             : 44.9 ms [WRITE: 44.9 ms]
latency 95th percentile    : 161.2 ms [WRITE: 161.2 ms]
latency 99th percentile    : 276.6 ms [WRITE: 276.6 ms]
latency 99.9th percentile  : 440.7 ms [WRITE: 440.7 ms]
latency max                : 1226.8 ms [WRITE: 1,226.8 ms]
total gc count             : 0
total gc memory            : 0.000 KiB
total gc time              : 0.0 seconds
avg gc time                : NaN ms
stddev gc time             : 0.0 ms
Total operation time       : 00:02:29
cmd: write no-warmup n=500000 -node 127.0.0.1 -rate threads=200 -mode native cql3 -schema keyspace=ksX -graph file=graphfile_local revision=kata_write_local title=Kata_Local
```
![screen shot 2018-04-12 at 12 28 42 pm](https://user-images.githubusercontent.com/7659560/38699536-2068404e-3e4d-11e8-9aed-f28f32821160.png)

```
kata_read_local
---------------------------------------
op rate                    : 2,864 op/s [READ: 2,864 op/s]
partition rate             : 2,864 pk/s [READ: 2,864 pk/s]
row rate                   : 2,864 row/s [READ: 2,864 row/s]
latency mean               : 69.5 ms [READ: 69.5 ms]
latency median             : 35.7 ms [READ: 35.7 ms]
latency 95th percentile    : 309.6 ms [READ: 309.6 ms]
latency 99th percentile    : 432.8 ms [READ: 432.8 ms]
latency 99.9th percentile  : 519.6 ms [READ: 519.6 ms]
latency max                : 1139.8 ms [READ: 1,139.8 ms]
total gc count             : 0
total gc memory            : 0.000 KiB
total gc time              : 0.0 seconds
avg gc time                : NaN ms
stddev gc time             : 0.0 ms
Total operation time       : 00:02:54
cmd: read no-warmup n=500000 -node 127.0.0.1 -rate threads=200 -mode native cql3 -schema keyspace=ksX -graph file=graphfile_local revision=kata_read_local title=Kata_Local
```
![screen shot 2018-04-12 at 12 28 56 pm](https://user-images.githubusercontent.com/7659560/38699541-249224a0-3e4d-11e8-85d9-f07118ec161b.png)

Complete results can be downloaded [here](https://github.com/kata-containers/runtime/files/1904676/graphfile_local.gz). (gunzip and open on your browser)

Charting and comparing the op rate and the mean latency for each run:

![oprate](https://user-images.githubusercontent.com/7659560/38758081-41353c5a-3f24-11e8-9f98-8942054287c8.png)
![latency](https://user-images.githubusercontent.com/7659560/38758087-4465f068-3f24-11e8-9b4f-5e91326685fd.png)

We see that the Op rate is slightly better for a local filesystem compared to a filesystem going through 9p. Similar behavior for latency, in this case, 
the latency is lower for the local fs compared to a filesystem going through 9p. Overall, we see less discrepancy between reads and writes compared
what we saw in [Part 1]({{< relref "2018-04-07-running-scylla-in-kata.md" >}}). This is mainly attributed to change in VM CPUs and default memory.

We conclude that tweaking the VM settings in terms of CPUs and memory can get better performance with Kata. In the case of raw containers we
still, see the better performance but this is also partly given that in the raw container case each container has access to all the machine
resources and has more direct access to the machine's hardware.

For more information about the Kata Containers project, you can visit https://katacontainers.io.

