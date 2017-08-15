#!/bin/bash

# Start the needed services
service postgresql start
service ssh start
sleep 20

# Start the ambari services
ambari-server start
ambari-agent start
sleep 20

# send command to start all services
echo 'services start' | java -jar /tmp/ambari-shell.jar --ambari.host=sandbox
sleep 30

# reduce time by forcing the system to leave safemode
su -c "hdfs dfsadmin -safemode leave" hdfs
sleep 10
echo 'services list' | java -jar /tmp/ambari-shell.jar --ambari.host=sandbox

su -c "hdfs dfs -mkdir /user/Nimrod" hdfs
su -c "hdfs dfs -chown -R Nimrod:Nimrod /user/Nimrod" hdfs
su -c "hdfs dfs -put /tmp/single* /user/Nimrod/" hdfs

bash
