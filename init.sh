#!/bin/bash
while read var ip; do
if [ ! -z "$var" ]
then
        sed -i "s/$var/$ip/" install.sh
		sed -i "s/$var/$ip/" install_etcd_master1.sh
        sed -i "s/$var/$ip/" install_etcd_master2.sh
        sed -i "s/$var/$ip/" install_etcd_master3.sh
fi
done < "servers"