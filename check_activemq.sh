#!/bin/bash
#
# author: danievanzyl (https://github.com/danievanzyl)
# version: 1.0
# license: http://www.apache.org/licenses/LICENSE-2.0.html
# read changelog for most up-to-date changes
##########################

#Global Variables
exit_status=-1
STATUS[0]="OK - "
STATUS[1]="WARNING - "
STATUS[2]="CRITICAL - "
STATUS[3]="UNKNOWN - "
activemq_user=activemq
LOCK=/opt/viamedia/activemq/data/kahadb/lock

#Functions
#
function check_lock {
	fuser -s $LOCK &> /dev/null
	return $?
}

function check_proc {
	local _proc
	_proc=$(ps hU ${activemq_user} |awk '{print $1}')
	if [ -z "$_proc" ];then
		return 1	
	else
		echo $_proc
		return 0
	fi
}

function main {
	#catch output
	pid=$(check_proc)
	#check return val
	if [ "$?" -eq "1" ]; then
		msg="No running process found!"
		exit_status=2
	else
    	check_lock	
		#check return val
		if [ "$?" -eq "0" ];then
			msg="Master running with pid: $pid"
		else
			msg="Slave idling with pid: $pid"
		fi
		exit_status=0
	fi
	echo ${STATUS[$exit_status]} $msg
	exit $exit_status
}

#
#EOFunctions

#run main function
#
main
