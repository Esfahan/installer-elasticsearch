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


# Install plugins
plugin_installer() {
  PLUGIN_BIN='/usr/share/elasticsearch/bin/elasticsearch-plugin'
  PLUGIN_NAME=$1
  if [ `sudo "${PLUGIN_BIN}" list | grep "${PLUGIN_NAME}" > /dev/null 2>&1; echo $?` == 0 ]; then
    echo "(skipping...)${PLUGIN_NAME} is already installed."
  else
    sudo "${PLUGIN_BIN}" install "${PLUGIN_NAME}"
    sudo "${PLUGIN_BIN}" list | grep "${PLUGIN_NAME}"
  fi
}

# to use japanese
plugin_installer analysis-kuromoji

sleep 5s

curl http://127.0.0.1:9200
