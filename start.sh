#!/bin/bash
service postgresql start
service ssh start
sleep 10
ambari-server start
ambari-agent start
sleep 10

/usr/jdk64/jdk1.8.0_112/bin/java -jar /tmp/ambari-shell.jar --ambari.host=sandbox << EOF
blueprint add --file /tmp/single-node-hdfs-yarn
cluster build --blueprint single-node-hdfs-yarn
cluster autoAssign
cluster create --exitOnFinish true
EOF

clear

# echo "\list" >> /tmp/1.txt
# echo "\q" >> /tmp/1.txt
# bash -c ' su -c "psql < /tmp/1.txt" postgres'
bash

# echo tasks | /usr/jdk64/jdk1.8.0_112/bin/java -jar /tmp/ambari-shell.jar --ambari.host=sandbox | egrep '(PENDING)|(QUEUED)|(IN_PROGRESS)' | wc -l
