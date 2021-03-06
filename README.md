# hdp-docker

![Build status](https://api.travis-ci.org/milonimrod/hdp-docker.svg?branch=master "travis-ci build status") - [travis-ci](https://travis-ci.org/milonimrod/hdp-docker)

This is my attempt to build a simple single node [HDP](https://hortonworks.com/products/data-center/hdp/) docker container.

The container installs the following HDP components:
1. Hadoop
1. Mapreduce
1. YARN
1. Zookeeper

The underlining system used is Ubuntu 14.04 LTS (unlike most other docker images I found that use centos)

In order to build the image:
```bash
docker build --add-host=sandbox:127.0.0.1 -t hdp-sandbox .
```

In order to run the image:
```bash
docker run -h sandbox -it compass
```

I wanted to have a static-IP to the server so I created a docker network using (Need to run once):

```bash
docker network create --subnet=172.18.0.0/16 hdpnet
```

And then run the image with the following command:
```bash
docker run -h sandbox --net hdpnet --ip 172.18.0.22 -itd hdp-sandbox
```
Notice: Don't forget to add `172.18.0.22 sandbox` to your hosts file

Tip: In order to access with localhost, you can map the following ports `-p 8080:8080 -p 8088:8088 -p 8030:8030 -p 8141:8141 -p 8025:8025 -p 8050:8050 -p 8020:8020`

### TODO
1. The name _sandox_ is currently hard coded in the files
1. The version of the HDP used is hardcoded
1. Add better documentaion and code rules of conduct

### Contribute
[Please see here](CONTRIBUTING.md)

### Rules of conduct
[Please see here](CODE_OF_CONDUCT.md)  
