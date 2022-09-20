#!/bin/bash

wget https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin
sudo apt-get update -y 
sudo apt-get upgrade -y
sudo apt-get install haproxy -y
tee /root/append <<EOF
frontend kubernetes
bind #haproxy#:6443
option tcplog
mode tcp
default_backend kubernetes-master-nodes


backend kubernetes-master-nodes
mode tcp
balance roundrobin
option tcp-check
server master1 #master1#:6443 check fall 3 rise 2
server master2 #master2#:6443 check fall 3 rise 2
server master3 #master3#:6443 check fall 3 rise 2
EOF

cat append >> /etc/haproxy/haproxy.cfg
systemctl restart haproxy

