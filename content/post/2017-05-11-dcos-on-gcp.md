---
title: "DC/OS on GCP"
date: 2017-05-11T16:28:29Z
lastmod: 2017-05-11T16:28:29Z
comments: true
categories:
 - gcp
 - dcos
 - mesos
 - google
tags: [ "gcp", "dcos", "mesos", "google" ]
keywords: gcp dcos mesos google Ricardo Aravena
description: Installing DC/OS in GCP
slug: dcos-on-gcp

---

DC/OS is the commercialized [Mesos](http://mesos.apache.org/) distribution + extras maintained by Mesosphere. I found it very straight forward to setup in GCP with the out of the box [Ansible scripts](https://github.com/raravena80/dcos-gce) provided by Mesosphere.

For starters I followed everything described in the [README](https://github.com/raravena80/dcos-gce/blob/master/README.md).

Then, I had to modify the `group_vars/all` file in the playbook

```
---
project: <my-gcp-project-id>
subnet: default
login_name: <my-gcp-login-id-with-no-email>
bootstrap_public_ip: 10.128.0.10 # This IP need to match the network in the zone
zone: us-central1-c

master_boot_disk_size: 200 # 200 is the recommended in GCP as of 05-2017
master_machine_type: n1-standard-1
master_boot_disk_type: pd-standard

agent_boot_disk_size: 200
agent_machine_type: n1-standard-1
agent_boot_disk_type: pd-standard
agent_instance_type: "MIGRATE"
agent_type: private
start_id: 0001
end_id: 0001

gcloudbin: gcloud
image: 'centos-7-v20161027'
image_project: 'centos-cloud'
bootstrap_public_port: 8080
cluster_name: cluster_name
scopes: "default=https://www.googleapis.com/auth/cloud-platform"
dcos_installer_filename: dcos_generate_config.sh
dcos_installer_download_path: "https://downloads.dcos.io/dcos/stable/{{ dcos_installer_filename }}"
home_directory: "/home/{{ login_name }}"
downloads_from_bootstrap: 2
dcos_bootstrap_container: dcosinstaller
```

Then to create the master I ran:

```
ansible-playbook -i hosts install.yml
```

![master](/img/2017-05-11-dcos-on-gcp/master.jpg "Master GCP")


and to create the agents or slaves I ran (for public facing ones):

```
ansible-playbook -i hosts add_agents.yml --extra-vars "start_id=0001 end_id=0002 agent_type=public"
```

![agent](/img/2017-05-11-dcos-on-gcp/agent.jpg "Agent GCP")

If you want to create private agents or slaves you can run something like:

```
ansible-playbook -i hosts add_agents.yml --extra-vars "start_id=0001 end_id=0002 agent_type=private"
```

Easy...

Then you can hit the DC/OS UI with the master's IP address over HTTPS (Make sure you open up port 443 to your IP address).

![dcosui](/img/2017-05-11-dcos-on-gcp/dcosui.jpg "DC/OS UI")

More to come...

