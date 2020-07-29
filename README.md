# K8S-playground

This repository it's like a lab of "Kubenetes the hard way" (https://github.com/kelseyhightower/kubernetes-the-hard-way)<br> 
I'm building installation scripts of kubernetes on bare-metal/VM's without using GCP as originally proposed.<br>

The goal it's to understand internals of kubernetes in terms of low-level installation and configuration.
Also, it's attempt to create ready-to-go installation/management script to create/scale k8s clusters.

`In development` 

# TODO
* add clanup functional for worker nodes
* add options to create custom number of masters/workers. I.e. increase deployment flexibility
* add auto-check for current context (interactive)
* optimize containerd setup (maybe replace with docker only)
* add dns providers
* add dashboard
* add tags to nodes representing control loops which installed on each node
* add RBAC rules
* add keycloak for services
* add ingress controller
