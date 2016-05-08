#!/bin/sh
#
# inventory.sh - Script to use ansible to build invertory list
#
#
HOSTS=/var/tmp/hosts
/etc/ansible/hosts > ${HOSTS}


echo "LOCATION,NAME,OS,SERVER TYPE,CPU,MEM(MB),NUMBER OF DISKS,TOTAL STORAGE(GB),PRIMARY IP ADDRRESS,POWER STATE,IS TEMPLATE,DESCRIPTION"

for DC in AU1 CA1 CA2 CA3 DE1 GB1 GB3 IL1 NE1 NY1 SG1 UC1 UT1 VA1 WA1
do
   for SERVER in `jq ".${DC}" ${HOSTS} | sed -e 's/"//g' -e 's/,//g' -e 's/\[//g' -e 's/\]//g'`
   do
      if [ ${SERVER} = "null" ]; then
         continue
      fi
      NAME=`jq "._meta.hostvars.${SERVER}.clc_data.name" ${HOSTS}`
      OS=`jq "._meta.hostvars.${SERVER}.clc_data.osType" ${HOSTS}`
      TYPE=`jq "._meta.hostvars.${SERVER}.clc_data.type" ${HOSTS}`
      LOCATION=`jq "._meta.hostvars.${SERVER}.clc_data.locationId" ${HOSTS}`
      DESCRIPTION=`jq "._meta.hostvars.${SERVER}.clc_data.description" ${HOSTS}`
      CPU=`jq "._meta.hostvars.${SERVER}.clc_data.details.cpu" ${HOSTS}`
      MEM=`jq "._meta.hostvars.${SERVER}.clc_data.details.memoryMB" ${HOSTS}`
      NUMDISKS=`jq "._meta.hostvars.${SERVER}.clc_data.details.diskCount" ${HOSTS}`
      TOTALSTORAGE=`jq "._meta.hostvars.${SERVER}.clc_data.details.storageGB" ${HOSTS}`
      POWERSTATE=`jq "._meta.hostvars.${SERVER}.clc_data.details.powerState" ${HOSTS}`
#      IPADDR=`jq "._meta.hostvars.${SERVER}.clc_data.details.ipAddresses.internal" ${HOSTS}`
      IPADDR=`jq "._meta.hostvars.${SERVER}.ansible_ssh_host" ${HOSTS}`
      TEMPLATE=`jq "._meta.hostvars.${SERVER}.clc_data.isTemplate" ${HOSTS}`

      echo "${LOCATION},${NAME},${OS},${TYPE},${CPU},${MEM},${NUMDISKS},${TOTALSTORAGE},${IPADDR},${POWERSTATE},${TEMPLATE},${DESCRIPTION}"
   done
done
