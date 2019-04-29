#!/bin/bash

##Check dependencies

for c in $(echo "wget php")
do
	if ! command -v $c >> /dev/null
	then
		echo "Command not found: $c"
		exit 1
	fi
done

## Check zabbix-web installation

for files in $(echo "zabbix.php index.php conf/zabbix.conf.php")
do
	if [ ! -f "$files" ]; then
		echo "Zabbix frontend archives not found"
		exit 1
	fi
done

## Download files

mkdir guardiankey
cd guardiankey
wget -q https://raw.githubusercontent.com/pauloangelo/guardiankey-api-php/master/guardiankey.class.php
wget -q https://raw.githubusercontent.com/pauloangelo/guardiankey-plugin-zabbix/master/register.php
cd ../
wget -q https://raw.githubusercontent.com/pauloangelo/guardiankey-api-php/master/examples/zabbix_index.php 
	
failed=0

echo "Do you want create a new register in GuardianKey, or using existent account? (n/e)"
read opt
case $opt in
	n) echo "Please insert e-mail to register in GuardianKey:"; read "email"; php register.php $email >> guardiankey/gk_register.php;;
	e) echo "Before instalation, do you need put register information in guardiankey/gk_register.php";;
	*) "Please insert valid option: n = new, e = existent";failed=1 
esac

if echo $failed | grep 0
then

	if ! mv index.php index.php-old
	then
	 failed=1
	fi

	if ! mv zabbix_index.php index.php
	then
	 failed=1
	fi

fi

if echo $failed | grep 1 > /dev/null
then
  echo "Installation failed"
else
  echo "Installation complete!"
fi
