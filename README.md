This setup is suitable for Ubuntu 22.04 target servers.

Switch to kubeans:v1.24.3 sh shell with command below.

docker run -it phenomrascalov/kubeans-ha:latest 

Generate ssh public key and private key with command below.

ssh-keygen

Share ssh public key to master and worker servers with command below.

Example:

ssh-copy-id -i ~/.ssh/id_rsa.pub root@10.10.10.10

ssh-copy-id -i ~/.ssh/id_rsa.pub root@10.10.10.11

.

.

.

ssh-copy-id -i ~/.ssh/id_rsa.pub root@10.10.10.12

Type the hostname of the master and worker servers into the inventory.yaml file.

Example inventory.yaml file

[haproxy]

10.10.10.10

[master1]

10.10.10.11

[master2]

10.10.10.12

[master3]

10.10.10.13

[worker]

10.10.10.14

[master:children]

master1

master2

master3

You can start the installation with the command below.

ansible-playbook main.yaml -i inventory.yaml
