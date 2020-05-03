#!/bin/bash

WORKFOLDER="/tmp/kubeconfig"
mkdir -p ${WORKFOLDER}
cd ${WORKFOLDER}

yum install -y socat conntrack ipset yum-utils device-mapper-persistent-data lvm2
swapoff -a
sysctl net.ipv4.ip_forward=1
POD_NETWORK_CIDR="10.244.0.0/16"

#Get docker
# Install Docker CE
### Add Docker repository.
yum-config-manager --add-repo \
  https://download.docker.com/linux/centos/docker-ce.repo
## Install Docker CE.
yum update -y && yum install -y \
  containerd.io-1.2.13 \
  docker-ce-19.03.8 \
  docker-ce-cli-19.03.8
## Create /etc/docker directory.
mkdir -p /etc/docker
# Setup daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF
mkdir -p /etc/systemd/system/docker.service.d
# Restart Docker
systemctl daemon-reload
systemctl restart docker

#Get kuberentes binaries
mkdir -p \
  /var/lib/kubelet \
  /var/lib/kube-proxy \
  /var/lib/kubernetes \
  /var/run/kubernetes

wget -q --timestamping \
  https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kubectl \
  https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kube-proxy \
  https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kubelet

chmod +x kubectl kube-proxy kubelet

mv kubectl kube-proxy kubelet /usr/local/bin/
mv ~/${HOSTNAME}-key.pem ~/${HOSTNAME}.pem /var/lib/kubelet/
mv ~/${HOSTNAME}.kubeconfig /var/lib/kubelet/kubeconfig
mv ~/ca.pem /var/lib/kubernetes/

sed -ri 's#HOSTNAME#'$HOSTNAME'#g' ~/kubelet-config.yaml
mv ~/kubelet-config.yaml /var/lib/kubelet/kubelet-config.yaml
mv ~/kubelet-service.systemd.unit /etc/systemd/system/kubelet.service
mv ~/kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig
mv ~/kube-proxy.systemd.unit /etc/systemd/system/kube-proxy.service

systemctl daemon-reload
systemctl enable kubelet kube-proxy
systemctl start kubelet kube-proxy







