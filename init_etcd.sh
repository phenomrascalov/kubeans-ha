while read var ip; do
        sed -i "s/$var/$ip/" install_etcd_master1.sh
        sed -i "s/$var/$ip/" install_etcd_master2.sh
        sed -i "s/$var/$ip/" install_etcd_master3.sh
done < "servers"