while read var ip; do
        sed -i "s/$var/$ip/" install.sh
done <<< "servers"