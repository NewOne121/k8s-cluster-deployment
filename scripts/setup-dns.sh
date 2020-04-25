#!/bin/bash

for NODE in $(awk -F ' ' '{print $2}' /tmp/k8s_nodes);
do
	if [ ! "$(grep "$NODE" /etc/hosts )" ];
	then
		ADDNODE=$(grep "$NODE" /tmp/k8s_nodes)
		echo "$ADDNODE" >> /etc/hosts
	fi
	nc -vz $NODE 22\
	&& echo "SSH Connection to node $NODE established"
done