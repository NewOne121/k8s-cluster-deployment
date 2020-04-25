#!/bin/bash

GITDIR='/opt/git/github/k8s-cluster-deployment'
WORKFOLDER='/opt/k8s_bootstrap'

if [ ! -d "$WORKFOLDER" ]
then
	mkdir -p "$WORKFOLDER"
fi

cd $WORKFOLDER ||\
echo "echo 'Can't change directory to bootstrap workfolder, exiting.'; kill -9 $$" | bash

#Generate management ssh key
if [ ! -d ""$WORKFOLDER"/ssh" ]
then
	mkdir -p "$WORKFOLDER"/ssh
	ssh-keygen -b 2048 -t rsa -f $WORKFOLDER/ssh/k8s-management -q -N ""
fi

#The cfssl and cfssljson command line utilities will be used to provision a PKI Infrastructure and generate TLS certificates.
wget -q --show-progress --https-only --timestamping \
  https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/linux/cfssl \
  https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/linux/cfssljson
chmod +x cfssl cfssljson
sudo mv cfssl cfssljson /usr/local/bin/

#Setup DNS
for NODE in $(awk -F ' ' '{print $2}' "$GITDIR"/config/k8s_nodes);
do
	if [ ! "$(grep "$NODE" /etc/hosts )" ];
	then
		ADDNODE=$(grep "$NODE" "$GITDIR"/config/k8s_nodes)
		echo "$ADDNODE" >> /etc/hosts
	fi
	ssh-copy-id -i $WORKFOLDER/ssh/k8s-management.pub "$NODE"
done

#Get kubectl
if [ ! -f "/usr/local/bin/kubectl" ]
then
	echo "Attempting to get kubectl."
	wget https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kubectl
	chmod +x kubectl
	sudo mv kubectl /usr/local/bin/\
	&& echo "Ok"
else
	echo "Kubectl already installed"
fi

