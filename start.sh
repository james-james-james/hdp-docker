#!/bin/bash
service postgresql start
service ssh start
sleep 10
ambari-server start
ambari-agent start
sleep 10

bash
