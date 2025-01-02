#MONITORING FILE SCRIPT BLA BLA !

#COMMENT !
<<COMMENT
MONITORING SCRIPT MAP ! 

COMMENT
#ENDOFCOMMENT

while true; do

	OS_ARCH=$(uname -m)
	KERNEL_VERSION=$(uname -r)
	PHYSICAL_PROC=$(lscpu | grep 'Socket(s)' | awk '{print $2}')
	VIRTUAL_PROC=$(lscpu | grep '^CPU(s):' | awk '{print $2}')
	TOTAL_RAM=$(free -h | grep '^Mem:' | awk '{print $2}')
	USED_RAM=$(free -h | grep '^Mem:' | awk '{print $3}')
	RAM_UTILIZATION=$(free  | grep '^Mem:' | awk '{printf("%.2f%%"), $3/$2*100}')
	TOTAL_STORAGE=$(df -h --total | grep 'total' | awk '{print $2}')
	USED_STORAGE=$(df -h --total | grep 'total' | awk '{print $3}')
	STORAGE_UTILIZATION=$(df --total | grep 'total' | awk '{printf("%.2f%%"), $3/$2*100}')
	CPU_UTILIZATION=$(mpstat | grep 'all' | awk '{print $4+$5+$6+$7+$8+$9+$10+$11+$12}')
	LAST_REBOOT=$(who -b | awk '{print $3, $4}')
	lvms_count=$(lsblk | grep -c 'lvm')
	if [ $lvms_count -gt 0 ]; then
		lvm_status="Active"
	else 
		lvm_status="Inactive"
	fi
	ACTIVE_CONNECTIONS=$(ss -t | grep 'ESTAB' | wc -l)
	active_users=$(who | awk '{print $1}' | uniq | wc -l)
	r_users=$(cat /etc/passwd | awk -F: '$3 >= 1000 && $3 != 65534' |wc -l)
	s_users=$(cat /etc/passwd | awk -F: '$3 <= 1000 && $3 != 65534' |wc -l)
	sn_user=$(cat /etc/passwd | awk -F: '$3 == 65534' |wc -l)
	IPV4_ADDRESS=$(ip addr show | grep 'inet' | awk 'NR==1{print $2}' | awk -F'/' '{print $1}')
	MAC_ADDRESS=$(ip addr show | grep 'link/ether' | awk 'NR==1{print $2}')
	SUDO_COMMANDS=$(journalctl _COMM=sudo | grep -c 'COMMAND')

OUTPUT="<:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::>
<::>                      Server SysInfo%  		      ::>
<::> ---------------------------------------------------------::>
<::> %OS Architecture : <$OS_ARCH> 
<::> %Kernel Version : <$KERNEL_VERSION> 
<::> %Physical CPUs : <$PHYSICAL_PROC> 
<::> %Virtual CPUs : <$VIRTUAL_PROC> 
<::> %Total RAM : <$TOTAL_RAM>
<::> %Used RAM : <$USED_RAM>
<::> %RAM Utilization : <$RAM_UTILIZATION>
<::> %Total Storage : <$TOTAL_STORAGE>
<::> %Used Storage : <$USED_STORAGE>
<::> %Storage Utilized : <$STORAGE_UTILIZATION>
<::> %CPU Utilization : <$CPU_UTILIZATION%>
<::> %Last Reboot : <$LAST_REBOOT>
<::> %LVM Status : <$lvm_status>
<::> %Active Connections : <$ACTIVE_CONNECTIONS> 
<::> %Users Catcher : <RU = $r_users | SU = $s_users | SNU = $sn_user | ACU $active_users>
<::> %IPv4 Address : <$IPV4_ADDRESS>
<::> %MAC Address : <$MAC_ADDRESS>
<::> %Sudo Commands Usage Count : <$SUDO_COMMANDS>
<:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::>
"
	echo "$OUTPUT" | wall
	sleep 600
done
