#!/bin/bash
sudo mkdir /etc/etcd /var/lib/etcd
sudo mv /root/ca.pem /root/kubernetes.pem /root/kubernetes-key.pem /etc/etcd
wget https://github.com/etcd-io/etcd/releases/download/v3.5.5/etcd-v3.5.5-linux-amd64.tar.gz
tar xvzf etcd-v3.5.5-linux-amd64.tar.gz
sudo mv etcd-v3.5.5-linux-amd64/etcd* /usr/local/bin/
tee /etc/systemd/system/etcd.service <<EOF
[Unit]
Description=etcd
Documentation=https://github.com/coreos


[Service]
ExecStart=/usr/local/bin/etcd \
  --name #master3# \
  --cert-file=/etc/etcd/kubernetes.pem \
  --key-file=/etc/etcd/kubernetes-key.pem \
  --peer-cert-file=/etc/etcd/kubernetes.pem \
  --peer-key-file=/etc/etcd/kubernetes-key.pem \
  --trusted-ca-file=/etc/etcd/ca.pem \
  --peer-trusted-ca-file=/etc/etcd/ca.pem \
  --peer-client-cert-auth \
  --client-cert-auth \
  --initial-advertise-peer-urls https://#master3#:2380 \
  --listen-peer-urls https://#master3#:2380 \
  --listen-client-urls https://#master3#:2379,http://127.0.0.1:2379 \
  --advertise-client-urls https://#master3#:2379 \
  --initial-cluster-token etcd-cluster-0 \
  --initial-cluster #master1#=https://#master1#:2380,#master2#=https://#master2#:2380,#master3#=https://#master3#:2380 \
  --initial-cluster-state new \
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5



[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd
ETCDCTL_API=3 etcdctl member list