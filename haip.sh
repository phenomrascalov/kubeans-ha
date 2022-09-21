haip=$(cat ./servers | grep  "#haproxy#" | grep -Eo '(^| )(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])($|[[:space:]])')
sed -r 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/"$haip"/ join-command.sh
rm -f ./servers