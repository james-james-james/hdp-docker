#!/bin/bash

# Start the needed services
service postgresql start
service ssh start
sleep 10

# Start the ambari services
ambari-server start
ambari-agent start
sleep 10

# send command to start all services
echo 'services start' | /usr/jdk64/jdk1.8.0_112/bin/java -jar /tmp/ambari-shell.jar --ambari.host=sandbox
sleep 10

bash
