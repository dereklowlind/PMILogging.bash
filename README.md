# PMILogging.bash

uses yannlambret’s WAS Agent to log JVM data from a IBM websphere server that is usually 
displayed on the WebSphere Performance Monitoring infrastructure (PMI)
https://github.com/yannlambret/websphere-nagios/blob/master/README.md

For each JVM log: session count, heapSize, heapUsed, pool-WebContainer-size, pool-WebContainer-activeCount, pool-WebContainer-hungCount
Pull those out every 5 minutes and drop them in a text file with a timestamp, can be parsed into a database
