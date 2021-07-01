# K8S-playground

This repository it's like a lab of "Kubenetes the hard way" (https://github.com/kelseyhightower/kubernetes-the-hard-way)<br> 
I'm building installation scripts of kubernetes on bare-metal/VM's without using GCP as originally proposed.<br>

The goal it's to understand internals of kubernetes in terms of low-level installation and configuration.
Also, it's attempt to create ready-to-go installation/management script to create/scale k8s clusters.

# Prerequisite (Before you go)

1. Configured linux VMs with hosts(dns) configuration (see config/k8s_nodes)
2. 2 network interfaces on each VM (NAT for external connections + Host only for internal networking. Default cluster CIDR 10.200.0.0/16)
3. Note that I'm using contanerd as a container runtime

`In development` 

# Components/addons
* Kube-router (https://github.com/cloudnativelabs/kube-router)
* Kubernetes dashboard

# TODO
* add cleanup functional for worker nodes
* add options to create custom number of masters/workers. I.e. increase/deployment flexibility
* add auto-check for current context (interactive)
* optimize containerd setup (add docker option)
* add dns providers
* hide dashboard behind keycloak
* add tags to nodes representing control loops which installed on each node
* add RBAC rules
* add keycloak for services

