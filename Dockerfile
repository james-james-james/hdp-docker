FROM ubuntu:14.04

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install wget screen vim initscripts iputils-ping net-tools openssh-server

RUN wget -O /etc/apt/sources.list.d/ambari.list http://public-repo-1.hortonworks.com/ambari/ubuntu14/2.x/updates/2.5.1.0/ambari.list
RUN wget http://public-repo-1.hortonworks.com/HDP/ubuntu14/2.x/updates/2.6.1.0/hdp.list -O /etc/apt/sources.list.d/hdp.list
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com B9733A7A07513CAD
RUN apt-get update
RUN apt-get -y install ambari-server
RUN ambari-server setup -s
RUN apt-get -y install ambari-agent

# RUN curl -o /tmp/ambari-shell.jar https://s3-eu-west-1.amazonaws.com/maven.sequenceiq.com/releases/com/sequenceiq/ambari-shell/0.1.31/ambari-shell-0.1.31.jar
ADD ambari-shell-0.1.31.jar /tmp/ambari-shell.jar
EXPOSE 8080
EXPOSE 8088 8030 8141 8025 8050

ADD internal-hostname.sh /etc/ambari-agent/conf/internal-hostname.sh
RUN chmod +x /etc/ambari-agent/conf/internal-hostname.sh
RUN sed -i "/\[agent\]/ a hostname_script=\/etc\/ambari-agent\/conf\/internal-hostname.sh" /etc/ambari-agent/conf/ambari-agent.ini
RUN sed -i "s/\"ifconfig\"/\"ifconfig eth0\"/" /usr/lib/python2.6/site-packages/ambari_agent/Facter.py
ADD single-node-hdfs-yarn /tmp/single-node-hdfs-yarn

RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# fix the 254 error code
RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config
RUN echo "UsePAM no" >> /etc/ssh/sshd_config

RUN apt-get -y install hadoop hadoop-hdfs libhdfs0 hadoop-yarn hadoop-mapreduce hadoop-client openssl
RUN apt-get -y install liblzo2-2 liblzo2-dev hadooplzo zookeeper

# Set the installed java version from ambari to be the default
RUN update-alternatives --install "/usr/bin/java" "java" "/usr/jdk64/$(ls -1 /usr/jdk64)/bin/java" 1

ADD install-cluster.sh .
RUN chmod +x install-cluster.sh
RUN ./install-cluster.sh

ADD start.sh .
RUN chmod +x start.sh
CMD ./start.sh
