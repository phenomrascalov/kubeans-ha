sed -i "s/#\$nrconf{restart} \= 'i';/\$nrconf{restart} \= 'a';/g" /etc/needrestart/needrestart.conf  
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x cfssl*
sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl
sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
wget https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin
sudo apt-get update -y 
sudo apt-get upgrade -y
sudo apt-get install haproxy -y
tee /root/append <<EOF
frontend kubernetes
bind 10.128.0.52:6443
option tcplog
mode tcp
default_backend kubernetes-master-nodes


backend kubernetes-master-nodes
mode tcp
balance roundrobin
option tcp-check
server master1 #master1:6443 check fall 3 rise 2
server master2 #master2:6443 check fall 3 rise 2
server master3 #master3:6443 check fall 3 rise 2
EOF

cat append >> /etc/haproxy/haproxy.cfg
systemctl restart haproxy

tee /root/ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "876000h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "876000h"
      }
    }
  }
}
EOF

tee /root/ca-csr.json <<EOF
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
  {
    "C": "IE",
    "L": "Cork",
    "O": "Kubernetes",
    "OU": "CA",
    "ST": "Cork Co."
  }
 ]
}
EOF

cfssl gencert -initca ca-csr.json | cfssljson -bare ca

tee /root/kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
  {
    "C": "IE",
    "L": "Cork",
    "O": "Kubernetes",
    "OU": "Kubernetes",
    "ST": "Cork Co."
  }
 ]
}
EOF

cfssl gencert \
-ca=ca.pem \
-ca-key=ca-key.pem \
-config=ca-config.json \
-hostname=#master1,#master2,#master3,#haproxy,127.0.0.1,kubernetes.default \
-profile=kubernetes kubernetes-csr.json | \
cfssljson -bare kubernetes