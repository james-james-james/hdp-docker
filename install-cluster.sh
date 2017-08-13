#!/bin/bash

# Start the needed services
service postgresql start
service ssh start
sleep 10

# Start the ambari services
ambari-server start
ambari-agent start
sleep 10

/usr/jdk64/jdk1.8.0_112/bin/java -jar /tmp/ambari-shell.jar --ambari.host=sandbox << EOF
blueprint add --file /tmp/single-node-hdfs-yarn
cluster build --blueprint single-node-hdfs-yarn
cluster autoAssign
cluster create --exitOnFinish true
exit
EOF

clear
clear


# Wait until all tasks are completed
lines=1
while [ $lines -gt 0 ]
do
        sleep 15
        lines=`echo tasks | /usr/jdk64/jdk1.8.0_112/bin/java -jar /tmp/ambari-shell.jar --ambari.host=sandbox | egrep '(PENDING)|(QUEUED)|(IN_PROGRESS)' | wc -l`
        echo $lines
done

amount_started=`echo 'services list' | /usr/jdk64/jdk1.8.0_112/bin/java -jar /tmp/ambari-shell.jar --ambari.host=sandbox | egrep -A 1000 'SERVICE\s+STATE' | tail -n +3 | head -n -2 | awk '{print $2}' | grep -v STARTED | wc -l`
if [ $amount_started -eq 0 ]; then
        echo "done"
        # stop all services
        echo 'services stop | /usr/jdk64/jdk1.8.0_112/bin/java -jar /tmp/ambari-shell.jar --ambari.host=sandbox'
        sleep 300
        ambari-agent stop
        sleep 5
        ambari-server stop
        sleep 5

        exit 0
else
        echo "there was a problem :("
        exit 1
fi
