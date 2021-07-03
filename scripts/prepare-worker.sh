#!/bin/bash

sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
systemctl stop containerd kubelet kube-proxy

WORKFOLDER="/tmp/kubeconfig"
mkdir -p ${WORKFOLDER}
cd ${WORKFOLDER}

yum install -y socat conntrack ipset yum-utils device-mapper-persistent-data lvm2
swapoff -a
sysctl net.ipv4.ip_forward=1


#Get kuberentes binaries
mkdir -p \
  /opt/cni/bin \
  /etc/containerd \
  /var/lib/kubelet \
  /var/lib/kube-proxy \
  /var/lib/kubernetes \
  /var/run/kubernetes

wget -q --timestamping \
  https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.15.0/crictl-v1.15.0-linux-amd64.tar.gz \
  https://github.com/opencontainers/runc/releases/download/v1.0.0-rc8/runc.amd64 \
  https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz \
  https://github.com/containerd/containerd/releases/download/v1.2.9/containerd-1.2.9.linux-amd64.tar.gz \
  https://dl.k8s.io/v1.21.2/kubernetes-node-linux-amd64.tar.gz

tar -xvf kubernetes-node-linux-amd64.tar.gz
cp kubernetes/node/bin/kubectl .
cp kubernetes/node/bin/kubelet .
cp kubernetes/node/bin/kube-proxy .

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
cp ~/containerd.config.toml /etc/containerd/config.toml
cp ~/containerd.systemd.unit /etc/systemd/system/containerd.service

###CNI & Contanerd
mkdir -p /etc/cni/net.d
cp ~/cni.conf ~/cni-loopback.conf /etc/cni/net.d

systemctl stop firewalld iptables
systemctl disable firewalld iptables
systemctl daemon-reload
systemctl enable kubelet kube-proxy
systemctl start kubelet kube-proxy







