#!/bin/bash

WORKFOLDER="/tmp/kubeconfig"
mkdir -p ${WORKFOLDER}
cd ${WORKFOLDER}

yum install -y socat conntrack ipset yum-utils device-mapper-persistent-data lvm2
swapoff -a
sysctl net.ipv4.ip_forward=1
POD_NETWORK_CIDR="10.244.0.0/16"


#Get kuberentes binaries
mkdir -p \
  /etc/cni/net.d \
  /opt/cni/bin \
  /var/lib/kubelet \
  /var/lib/kube-proxy \
  /var/lib/kubernetes \
  /var/run/kubernetes

wget -q --timestamping \
  https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.15.0/crictl-v1.15.0-linux-amd64.tar.gz \
  https://github.com/opencontainers/runc/releases/download/v1.0.0-rc8/runc.amd64 \
  https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz \
  https://github.com/containerd/containerd/releases/download/v1.2.9/containerd-1.2.9.linux-amd64.tar.gz \
  https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kubectl \
  https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kube-proxy \
  https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kubelet

mkdir containerd
tar -xvf crictl-v1.15.0-linux-amd64.tar.gz
tar -xvf containerd-1.2.9.linux-amd64.tar.gz -C containerd
tar -xvf cni-plugins-linux-amd64-v0.8.2.tgz -C /opt/cni/bin/
cp runc.amd64 runc
chmod +x crictl kubectl kube-proxy kubelet runc
cp crictl kubectl kube-proxy kubelet runc /usr/local/bin/
cp containerd/bin/* /bin/

cp kubectl kube-proxy kubelet /usr/local/bin/
cp ~/${HOSTNAME}-key.pem ~/${HOSTNAME}.pem /var/lib/kubelet/
cp ~/${HOSTNAME}.kubeconfig /var/lib/kubelet/kubeconfig
cp ~/ca.pem /var/lib/kubernetes/

sed -ri 's#HOSTNAME#'$HOSTNAME'#g' ~/kubelet-config.yaml
cp ~/kubelet-config.yaml /var/lib/kubelet/kubelet-config.yaml
cp ~/kubelet-service.systemd.unit /etc/systemd/system/kubelet.service
cp ~/kube-proxy-config.yaml /var/lib/kube-proxy/kube-proxy-config.yaml
cp ~/kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig
cp ~/kube-proxy.systemd.unit /etc/systemd/system/kube-proxy.service
cp ~/cni.conf /etc/cni/net.d/10-bridge.conf
cp ~/cni-loopback.conf /etc/cni/net.d/99-loopback.conf
cp ~/containerd.config.toml /etc/containerd/config.toml
cp ~/containerd.systemd.unit /etc/systemd/system/containerd.service

#systemctl daemon-reload
#systemctl enable kubelet kube-proxy
#systemctl start kubelet kube-proxy







