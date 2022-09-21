while read list; do

        ip=$(ansible-inventory -i inventory.yaml --list | jq -r ".$list.hosts[]")

        list="#$list#"

        echo $list $ip >> servers

done < list
echo "" >> servers