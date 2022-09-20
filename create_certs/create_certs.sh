#!/bin/bash
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x cfssl*
sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl
sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson

cfssl gencert -initca ca-csr.json | cfssljson -bare ca

sleep 1

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -hostname=#master1#,#master2#,#master3#,#haproxy#,127.0.0.1,kubernetes.default -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes