while read list; do
if [ ! -z "$list" ]
then

        ip=$(ansible-inventory -i inventory.yaml --list | jq -r ".$list.hosts[]")

        list="#$list#"

        echo $list $ip >> servers
fi

done < list
echo "" >> servers