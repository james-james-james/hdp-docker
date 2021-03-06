#!/bin/bash

# Start the needed services
service postgresql start
service ssh start
sleep 20

# Start the ambari services
ambari-server start
ambari-agent start
sleep 20

java -jar /tmp/ambari-shell.jar --ambari.host=sandbox << EOF
blueprint add --file /tmp/single-node-hdfs-yarn
cluster build --blueprint single-node-hdfs-yarn
cluster autoAssign
cluster create --exitOnFinish true
exit
EOF

# Wait until all tasks are completed
lines=1
while [ $lines -gt 0 ]
do
        sleep 20
        lines=`echo tasks | java -jar /tmp/ambari-shell.jar --ambari.host=sandbox | egrep '(PENDING)|(QUEUED)|(IN_PROGRESS)' | wc -l`
        echo "Currently found $lines tasks running"
done

# verfiy that all the services started correcty
amount_started=`echo 'services list' | java -jar /tmp/ambari-shell.jar --ambari.host=sandbox | egrep -A 1000 'SERVICE\s+STATE' | tail -n +3 | head -n -2 | awk '{print $2}' | grep -v STARTED | wc -l`
if [ $amount_started -eq 0 ]; then
        echo "done"
        # stop all services
        echo 'services stop' | java -jar /tmp/ambari-shell.jar --ambari.host=sandbox
        sleep 90
        echo 'services list' | java -jar /tmp/ambari-shell.jar --ambari.host=sandbox

        echo "stop ambari agent"
        ambari-agent stop
        sleep 10

        echo "stop ambari server"
        ambari-server stop
        sleep 10

        exit 0
else
        echo "there was a problem :("
        exit 1
fi
