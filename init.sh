#!/bin/bash
while read var ip; do
if [ ! -z "$var" ]
then
        sed -i "s/$var/$ip/g" install.sh
        sleep 1
        sed -i "s/$var/$ip/g" install_etcd_master1.sh
        sleep 1
        sed -i "s/$var/$ip/g" install_etcd_master2.sh
        sleep 1
        sed -i "s/$var/$ip/g" install_etcd_master3.sh
        sleep 1
        sed -i "s/$var/$ip/g" config.yaml
        sleep 1
        sed -i "s/$var/$ip/g" create_certs/create_certs.sh
        sleep 1
        sed -i "s/$var/$ip/g" haproxy.cfg	
fi
done < "servers"