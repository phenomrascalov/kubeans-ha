#!/bin/bash

cfssl gencert -initca ca-csr.json | cfssljson -bare ca

sleep 1

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -hostname=#master1#,#master2#,#master3#,#haproxy#,127.0.0.1,kubernetes.default -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes