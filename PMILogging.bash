#!/bin/bash
# PMILogging.bash
# by Derek Lowlind
# uses yannlambret’s WAS Agent to log JVM data from a IBM websphere server that is usually 
# displayed on the WebSphere Performance Monitoring infrastructure (PMI)
# https://github.com/yannlambret/websphere-nagios/blob/master/README.md#running-queries documentation of commands

# For each JVM log: session count, heapSize, heapUsed, pool-WebContainer-size, pool-WebContainer-activeCount, pool-WebContainer-hungCount
# Pull those out every 5 minutes and drop them in a text file with a timestamp, can be parsed into a database

#   Crontab:
# * /5 * * * *  /scripts/PMILogging.sh
# Remember to remove the ^M characters from this file with VI Editor when you deploy it to a UNIX environment.

TODAYSDATE=$(date +%Y%m%d)
LOGDIR=/PMILogs
LOGFILE="${LOGDIR}/${TODAYSDATE}PMILog.txt"
hostname=$(hostname)

# Make sure we have the log directory to write to
if [ ! -d $LOGDIR ]; then mkdir $LOGDIR; fi

JVMs[0]=$(wget  -q -O - http://localhost:9090/wasagent/WASAgent --post-data="hostname=$hostname&port=8080&application=DefaultApplication.ear#DefaultWebApplication.war,250,275&jvm=heapUsed,90,95&thread-pool=WebContainer,90,95")
JVMs[1]=$(wget  -q -O - http://localhost:9090/wasagent/WASAgent --post-data="hostname=$hostname&port=8081&application=DefaultApplication.ear#DefaultWebApplication.war,250,275&jvm=heapUsed,90,95&thread-pool=WebContainer,90,95")

# output format
#sessioncount|heapSize|heapUsed|pool-WebContainer-size|pool-WebContainer-activeCount|pool-WebContainer-hungCount|

reArray=('DefaultWebApplication.war=([0-9]+)' 'jvm-heapSize=([0-9]+)' 'jvm-heapUsed=([0-9]+)'  'pool-WebContainer-size=([0-9]+)' 'pool-WebContainer-activeCount=([0-9]+)' 'pool-WebContainer-hungCount=([0-9]+)')
output=""
for DATA in "${JVMs[@]}"; do
	echo "$DATA"
done
for DATA in "${JVMs[@]}"; do
	for re in "${reArray[@]}"; do
    	if [[ "$DATA" =~ $re ]]; then
        	output+="${BASH_REMATCH[1]}|"
    	else
        	output+="0|"
    	fi
	done
	output+="-"
done
echo "${output}" >> "$LOGFILE"


 
