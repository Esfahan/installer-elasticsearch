#!/bin/bash

# java
sudo yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel

if [ `cat /etc/profile | grep 'JAVA_HOME' > /dev/null 2>&1; echo $?` == 0 ]; then
  echo '(skipping...)environment is alreday set.'
else
  sudo /bin/bash -lc 'cat java/environment >> /etc/profile'
  source /etc/profile
fi

# elasticsearch
sudo cp repo/elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo
sudo yum -y install elasticsearch
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch

# to use japanese
if [ `sudo /usr/share/elasticsearch/bin/elasticsearch-plugin list | grep analysis-kuromoji > /dev/null 2>&1; echo $?` == 0 ]; then
  echo '(skipping...)analysis-kuromoji is already installed.'
else
  sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-kuromoji
  sudo /usr/share/elasticsearch/bin/elasticsearch-plugin list | grep analysis-kuromoji
fi

sleep 5s

curl http://127.0.0.1:9200
