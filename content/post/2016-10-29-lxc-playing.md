---
title: "LXC Playing"
date: 2016-10-29T16:28:29Z
lastmod: 2016-10-29T16:28:29Z
categories: 
 - docker
 - lxc
tags: [ "cloudnative", "lxc" ]
keywords: cloudnative lxc docker Ricardo Aravena
description: LXC comments and impressions
slug: lxc-playing

---

Over the last couple of years Docker has seen incredible growth across the tech industry. Its use ties together with deployment of Microservices in most Cloud based companies. Docker is easy to use and its in constant development.
In the last month I decided to venture and try something different that has been around even before Docker but in a more primitive form. You see containers have been around before Docker for a long time and even before that with the introduction of chroot in 1979. Containers were first introduced in Solaris in 2005 with the introduction of Solaris Containers, described as 'chroot' on steroids. Then later in 2008 with adoption of the Containers name by LXC. (what Docker was based on initially) and also the inclusion of user namespaces in the Linux Kernel 3.8.

Enter the current version of LXC introduced with Ubuntu 16.04 LTS, written in Golang and makes use of Linux namespaces available on the later Kernels. It has two components: a client (lxc) and a daemon (lxd). It comes installed as a default in the later Debian and Ubuntu distributions.

I found LXC very easy to use with the advantage that your containers are persistent even after reboots !
To create a container you can simply use the 'launch command' with the image that you'd like to use:

```bash

$ lxc launch ubuntu:16.04
Creating pleasant-kite
Starting pleasant-kite
$ lxc list
+---------------+---------+---------------------+-----------------------------------------------+------------+-----------+
| NAME | STATE | IPV4 | IPV6 | TYPE | SNAPSHOTS |
+---------------+---------+---------------------+-----------------------------------------------+------------+-----------+
| pleasant-kite | RUNNING | 10.94.170.28 (eth0) | fd34:3f6e:9ec5:3b20:216:3eff:fe0f:9bfa (eth0) | PERSISTENT | 0 |
+---------------+---------+---------------------+-----------------------------------------------+------------+-----------+
$
```

If you want to enter the container you can run the exec command

```bash
$ lxc exec pleasant-kite /bin/bash
root@pleasant-kite:~#
```

You see LXC feels a bit more like VM than Docker does. In Docker every container is tied to CMD (Command) or ENTRYPOINT. Once that ENTRYPOINT is not there, the container doesn't exists. I'm not inferring that ones better than the other but either approach could have its different applications.

In LXC when you enter the container you see that there's a set a processes including and INIT process. Something that doesn't exist in Docker because process 1 in Docker is your ENTRYPOINT.

```bash
root@pleasant-kite:~# ps -Af
UID PID PPID C STIME TTY TIME CMD
root 1 0 0 18:38 ? 00:00:00 /sbin/init
root 45 1 0 18:38 ? 00:00:00 /lib/systemd/systemd-journald
root 48 1 0 18:38 ? 00:00:00 /lib/systemd/systemd-udevd
message+ 88 1 0 18:38 ? 00:00:00 /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation
root 89 1 0 18:38 ? 00:00:00 /usr/sbin/cron -f
root 90 1 0 18:38 ? 00:00:00 /lib/systemd/systemd-logind
root 92 1 0 18:38 ? 00:00:00 /usr/lib/accountsservice/accounts-daemon
syslog 93 1 0 18:38 ? 00:00:00 /usr/sbin/rsyslogd -n
daemon 96 1 0 18:38 ? 00:00:00 /usr/sbin/atd -f
root 97 1 0 18:38 ? 00:00:00 /usr/lib/snapd/snapd
root 114 1 0 18:38 ? 00:00:00 /usr/lib/policykit-1/polkitd --no-debug
root 230 1 0 18:38 ? 00:00:00 /sbin/dhclient -1 -v -pf /run/dhclient.eth0.pid -lf /var/lib/dhcp/dhclient.eth0.leases -I -
root 313 1 0 18:38 ? 00:00:00 /usr/sbin/sshd -D
root 347 1 0 18:38 console 00:00:00 /sbin/agetty --noclear --keep-baud console 115200 38400 9600 vt220
root 409 0 0 18:40 ? 00:00:00 /bin/bash
root 419 409 0 18:44 ? 00:00:00 ps -Af
root@pleasant-kite:~#
```

Hey, it looks just like a separate machine !

When you exit the container you still see that those processes are running on the main machine's process namespace.


```bash
root@pleasant-kite:~# exit
exit
$ ps -Af | grep init
root 1 0 0 Oct21 ? 00:00:09 /sbin/init
100000 28653 28634 0 18:38 ? 00:00:00 /sbin/init <-- This is for the container
ubuntu 29701 24955 0 18:47 pts/2 00:00:00 grep --color=auto init
$
```

LXC also allows you to name your containers whatever you want

```bash
$ lxc launch ubuntu:16.04 my-nice-container
Creating my-nice-container
Starting my-nice-container
$ lxc list
+-------------------+---------+----------------------+-----------------------------------------------+------------+-----------+
| NAME | STATE | IPV4 | IPV6 | TYPE | SNAPSHOTS |
+-------------------+---------+----------------------+-----------------------------------------------+------------+-----------+
| my-nice-container | RUNNING | 10.94.170.109 (eth0) | fd34:3f6e:9ec5:3b20:216:3eff:fe3f:f1d1 (eth0) | PERSISTENT | 0 |
+-------------------+---------+----------------------+-----------------------------------------------+------------+-----------+
| pleasant-kite | RUNNING | 10.94.170.28 (eth0) | fd34:3f6e:9ec5:3b20:216:3eff:fe0f:9bfa (eth0) | PERSISTENT | 0 |
+-------------------+---------+----------------------+-----------------------------------------------+------------+-----------+
$
```

You can even SSH into the container (provided that you have the right credentials)

```bash

$ ssh ubuntu@10.94.170.109
The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.
Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@my-nice-container:~$
```

Pretty cool heh ?

Keep in mind the the LXD daemon is running all the time

```bash
$ ps -Af | grep lxd | grep -v grep
lxd 1084 1 0 Oct21 ? 00:00:00 dnsmasq -s lxd -S /lxd/ -u lxd --strict-order --bind-interfaces --pid-file=/run/lxd-bridge//dnsmasq.pid --dhcp-no-override --except-interface=lo --interface=lxdbr0 --dhcp-leasefile=/var/lib/lxd-bridge//dnsmasq.lxdbr0.leases --dhcp-authoritative --listen-address 10.94.170.1 --dhcp-range 10.94.170.2,10.94.170.254 --dhcp-lease-max=252 --dhcp-range=fd34:3f6e:9ec5:3b20::1,ra-stateless,ra-names --listen-address fd34:3f6e:9ec5:3b20::1
root 19164 1 0 Oct21 ? 00:00:53 /usr/bin/lxd --group lxd --logfile=/var/log/lxd/lxd.log
root 28634 1 0 18:38 ? 00:00:00 [lxc monitor] /var/lib/lxd/containers pleasant-kite
root 29720 1 0 18:50 ? 00:00:00 [lxc monitor] /var/lib/lxd/containers my-nice-container
```

Let's reboot the server and see what happens. Make sure that your containers are set to autoboot, otherwise they will be in STOPPED state

```bash
$ lxc config set my-nice-container boot.autostart true
$ lxc config set pleasant-kite boot.autostart true
$ date
Fri Oct 28 18:56:17 UTC 2016
$ uptime
18:56:24 up 7 days, 18:55, 1 user, load average: 0.01, 0.04, 0.01
$ sudo reboot
...
```

After reboot:

```bash
$ date
Fri Oct 28 19:14:06 UTC 2016
$ uptime
19:14:08 up 0 min, 1 user, load average: 0.58, 0.19, 0.07
$ date
Fri Oct 28 19:14:09 UTC 2016
ubuntu@ip-192-168-1-26:~$ lxc list
+-------------------+---------+----------------------+-----------------------------------------------+------------+-----------+
| NAME | STATE | IPV4 | IPV6 | TYPE | SNAPSHOTS |
+-------------------+---------+----------------------+-----------------------------------------------+------------+-----------+
| my-nice-container | RUNNING | 10.94.170.109 (eth0) | fd34:3f6e:9ec5:3b20:216:3eff:fe3f:f1d1 (eth0) | PERSISTENT | 0 |
+-------------------+---------+----------------------+-----------------------------------------------+------------+-----------+
| pleasant-kite | RUNNING | 10.94.170.28 (eth0) | fd34:3f6e:9ec5:3b20:216:3eff:fe0f:9bfa (eth0) | PERSISTENT | 0 |
+-------------------+---------+----------------------+-----------------------------------------------+------------+-----------+
```

Containers are up and running !

There's also a wide list of different images that LXC supports you can get them by running the images command:

```bash
$ lxc image list images:
+---------------------------------+--------------+--------+------------------------------------------+---------+----------+-------------------------------+
| ALIAS | FINGERPRINT | PUBLIC | DESCRIPTION | ARCH | SIZE | UPLOAD DATE |
+---------------------------------+--------------+--------+------------------------------------------+---------+----------+-------------------------------+
| alpine/3.1 (3 more) | 585a5cae5e78 | yes | Alpine 3.1 amd64 (20161028_17:50) | x86_64 | 2.32MB | Oct 28, 2016 at 12:00am (UTC) |
+---------------------------------+--------------+--------+------------------------------------------+---------+----------+-------------------------------+
| alpine/3.1/armhf (1 more) | 28a551b04ff1 | yes | Alpine 3.1 armhf (20161028_17:50) | armv7l | 1.55MB | Oct 28, 2016 at 12:00am (UTC) |
+---------------------------------+--------------+--------+------------------------------------------+---------+----------+-------------------------------+
```

Obviously you can create your own images.

The latest version of LXC is still not supported in Kubernetes, Mesos or other container management tools, but there are plans to
suppport it: https://github.com/kubernetes/kubernetes/issues/6862

So there you have it. Although LXC is in active development, you can easily see that this a very good alternative to Docker. Having the ability to persist containers and having an init process could work very well for certain applications. i.e. Emulating real servers in test environments. I'm excited to see what's next in LXC and how it can help in different ways take advantage of containerized applications and containers themselves.

For more information on LXC you can visit their page and their github pages.
https://linuxcontainers.org/

