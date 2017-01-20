#!/bin/bash

# specify jenkins plugins
JENKINS_PLUGINS='git github build-monitor-plugin build-blocker-plugin'

# setup jenkins yum repo and import key
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key

# install jenkins and java
sudo yum -y install jenkins-1.651
sudo yum -y install java

# start jenkins service
sudo service jenkins start

# download jenkins-cli tool
sudo wget -O /var/lib/jenkins/jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar

# install jenkins plugins using jenkins-cli tool
for PLUGIN in $JENKINS_PLUGINS; do
  sudo java -jar /var/lib/jenkins/jenkins-cli.jar -s http://localhost:8080 install-plugin $PLUGIN -deploy
  RC=$?
  sleep 1
  if [ $RC -ne 0 ]; then
    exit 1
  else
    continue
  fi
done

# restart jenkins
sudo service jenkins restart

exit 0
