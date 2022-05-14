#!/bin/bash
rpm -qa|grep expect &> /dev/null
if [ $? -ne 0 ];then
	yum -y install expect
fi
rm -rf /root/.ssh
ssh-keygen -f /root/.ssh/id_rsa -N ''
passwd="密码"
ssh_expect () {
	expect -c "set timeout -1;
	spawn ssh-copy-id root@$1
	
	expect {
	"yes/no" { send -- yes\r;exp_continue;}
	"password" {send -- $passwd\r;}
	}
	expect eof"
}

for ip in `cat /server/hosts.txt  | awk '{print $1}'`
do
	passwd=`grep "$ip" /server/hosts.txt | awk '{print $NF}'`
	echo "$ip $passwd"
	ssh_expect $ip
done
