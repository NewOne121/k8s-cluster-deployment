# K8S-playground (Kubernetes version 1.21.2)

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
* Coredns (https://github.com/coredns/deployment/tree/master/kubernetes)
* Keycloak + oauth2_proxy for dashboard/services authentication

# TODO
* ~~add dashboard~~
* add option to choose between docker and containerd as runtime
* ~~add dns providers~~
* ~~hide dashboard behind keycloak and oauth2-proxy~~
* ~~add RBAC rules~~
* ~~add keycloak for services~~

