#!/bin/bash 
#######################################################################################
#Script Name    :alertmemory.sh
#Description    :send alert mail when server memory is running low
#Args           :       
#Author         :Aaron Kili Kisinga and Hand Medeiros and Guilherme Pontess
#Email          :aaronkilik@gmail.com || handerson.medeiros@tembici.com
#License       : GNU GPL-3	
#######################################################################################
## declare mail variables
## sudo apt-get install ssmtp
## email subject
## https://github.com/gpontesss/terminal-send-email
## https://www.tecmint.com/shell-script-to-send-email-alert-when-memory-low/

subject="Server Memory Status Alert"

## get total free memory size in megabytes(MB) 
free=$(free -mt | grep Mem | awk '{print $4}')
memory=$(free -mt | grep Mem | awk '{print $2}')

total_free=$((($free * 100)/ $memory))
## If free memory is less or equals to 15%
if [[ "$total_free" -le 15  ]]; then
	# Send email if system memory is running low
	if [ -e last_moment_sended_email ]; then
		# Date 1 : last moment sended email
		dt1=$(<last_moment_sended_email)
		t1=`date --date="$dt1" +%s`
		# Date 2 : Current date
		dt2=`date +%Y-%m-%d\ %H:%M:%S`
		t2=`date --date="$dt2" +%s`

		# Compute the difference in dates in seconds
		let "tDiff=$t2-$t1"
		# Compute the approximate hour difference
		let "hDiff=$tDiff/60"
	else 
		hDiff=61
	fi

	if [[ "$hDiff" -gt 60 ]]; then
		echo "Send Email"
		addr_list="addr_list"
		while read email_to; do
		    list_process=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head)

		    first_pid=$(awk 'NR==2{print $1}' <<< "$list_process")
		    second_pid=$(awk 'NR==3{print $1}' <<< "$list_process")

		    process_one=$(pmap $first_pid | awk 'NR==1{print $0}')
		    process_two=$(pmap $second_pid | awk 'NR==1{print $0}')
		    
		    echo -e "$list_process \n\n ===== PROCESS DETAILS ===== \n # $process_one \n # $process_two " | mail -s "$subject" "$email_to"
		done < addr_list

	    rm last_moment_sended_email
	    echo `date +%Y-%m-%d\ %H:%M:%S` > last_moment_sended_email		
	fi
fi

echo `date +%Y-%m-%d\ %H:%M:%S` > last_moment_verified

exit 0

# SSMTP
# https://wiki.debian.org/sSMTP
# http://www.devin.com.br/mail-via-linha-de-comando/
# https://tecadmin.net/sendmail-to-relay-emails-through-gmail-stmp/
# https://stackoverflow.com/questions/10359437/sendmail-how-to-configure-sendmail-on-ubuntu